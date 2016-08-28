/***********************************************************************
* pc_stats.c
*
*  Pointclound patch statistics generation.
*
*  Copyright (c) 2013 OpenGeo
*
***********************************************************************/

#include "pc_api_internal.h"
#include <float.h>


#include <sys/time.h>
#include <unistd.h>

#include <omp.h>

#define NTHREADS (4)
uint64_t micros_since_epoch2(){
    struct timeval tv;
    uint64_t micros = 0;
    gettimeofday(&tv, NULL);  
    micros =  ((uint64_t)tv.tv_sec) * 1000000 + tv.tv_usec;
    return micros;
}

/*
* Instantiate a new PCDOUBLESTATS for calculation, and set up
* initial values for min/max/sum
*/
static PCDOUBLESTATS *
pc_dstats_new(int ndims)
{
	int i;
	PCDOUBLESTATS *stats = pcalloc(sizeof(PCDOUBLESTATS));
	stats->dims = pcalloc(sizeof(PCDOUBLESTAT)*ndims);
	for ( i = 0; i < ndims; i++ )
	{
		stats->dims[i].min = DBL_MAX;
		stats->dims[i].max = -1 * DBL_MAX;
		stats->dims[i].sum = 0;
	}
	stats->npoints = 0;
	return stats;
}

static void
pc_dstats_free(PCDOUBLESTATS *stats)
{
	if ( ! stats) return;
	if ( stats->dims ) pcfree(stats->dims);
	pcfree(stats);
	return;
}

/**
* Free the standard stats object for in memory patches
*/
void
pc_stats_free(PCSTATS *stats)
{
	if ( stats->min.readonly != PC_TRUE )
		pcfree(stats->min.data);

	if ( stats->max.readonly != PC_TRUE )
		pcfree(stats->max.data);

	if ( stats->avg.readonly != PC_TRUE )
		pcfree(stats->avg.data);

	pcfree(stats);
	return;
}

/**
* Build a standard stats object on top of a serialization, allocate just the
* point shells and set the pointers to look into the data area of the
* serialization.
*/
PCSTATS *
pc_stats_new_from_data(const PCSCHEMA *schema, const uint8_t *mindata, const uint8_t *maxdata, const uint8_t *avgdata)
{
	/*size_t sz = schema->size;*/
	PCSTATS *stats = pcalloc(sizeof(PCSTATS));
	/* All share the schema with the patch */
	stats->min.schema = schema;
	stats->max.schema = schema;
	stats->avg.schema = schema;
	/* Data points into serialization */
	stats->min.data = (uint8_t*)mindata;
	stats->max.data = (uint8_t*)maxdata;
	stats->avg.data = (uint8_t*)avgdata;
	/* Can't modify external data */
	stats->min.readonly = PC_TRUE;
	stats->max.readonly = PC_TRUE;
	stats->avg.readonly = PC_TRUE;
	/* Done */
	return stats;
}

/**
* Build a standard stats object with read/write memory, allocate the
* point shells and the data areas underneath. Used for initial calcution
* of patch stats, when objects first created.
*/
static PCSTATS *
pc_stats_new(const PCSCHEMA *schema)
{
	/*size_t sz = schema->size;*/
	PCSTATS *stats = pcalloc(sizeof(PCSTATS));
	stats->min.schema = schema;
	stats->max.schema = schema;
	stats->avg.schema = schema;
	stats->min.readonly = PC_FALSE;
	stats->max.readonly = PC_FALSE;
	stats->avg.readonly = PC_FALSE;
	stats->min.data = pcalloc(schema->size);
	stats->max.data = pcalloc(schema->size);
	stats->avg.data = pcalloc(schema->size);
	return stats;
}

/**
* Allocate and populate a new PCSTATS from the raw data in
* a PCDOUBLESTATS
*/
static PCSTATS *
pc_stats_new_from_dstats(const PCSCHEMA *schema, const PCDOUBLESTATS *dstats)
{
	int i;
	PCSTATS *stats = pc_stats_new(schema);

	for ( i = 0; i < schema->ndims; i++ )
	{
		pc_point_set_double(&(stats->min), schema->dims[i], dstats->dims[i].min);
		pc_point_set_double(&(stats->max), schema->dims[i], dstats->dims[i].max);
		pc_point_set_double(&(stats->avg), schema->dims[i], dstats->dims[i].sum / dstats->npoints);
	}
	return stats;
}

PCSTATS *
pc_stats_clone(const PCSTATS *stats)
{
	PCSTATS *s;
	if ( ! stats ) return NULL;
	s = pcalloc(sizeof(PCSTATS));
	s->min.readonly = s->max.readonly = s->avg.readonly = PC_FALSE;
	s->min.schema = stats->min.schema;
	s->max.schema = stats->max.schema;
	s->avg.schema = stats->avg.schema;
	s->min.data = pcalloc(stats->min.schema->size);
	s->max.data = pcalloc(stats->max.schema->size);
	s->avg.data = pcalloc(stats->avg.schema->size);
	memcpy(s->min.data, stats->min.data, stats->min.schema->size);
	memcpy(s->max.data, stats->max.data, stats->max.schema->size);
	memcpy(s->avg.data, stats->avg.data, stats->avg.schema->size);
	return s;
}





int
pc_patch_uncompressed_compute_stats2(PCPATCH_UNCOMPRESSED *pa)
{
	uint64_t start = micros_since_epoch2();
        int i, j;
        const PCSCHEMA *schema = pa->schema;
        double val;
        PCDOUBLESTATS *dstats = pc_dstats_new(pa->schema->ndims);

        if ( pa->stats )
                pc_stats_free(pa->stats);

        /* Point on stack for fast access to values in patch */
        PCPOINT pt;
        pt.readonly = PC_TRUE;
        pt.schema = schema;
        pt.data = pa->data;

        /* We know npoints right away */
        dstats->npoints = pa->npoints;


        for ( i = 0; i < pa->npoints; i++ )
        {
                for ( j = 0; j < schema->ndims; j++ )
                {
                        pc_point_get_double(&pt, schema->dims[j], &val);
                        /* Check minimum */
                        if ( val < dstats->dims[j].min )
                                dstats->dims[j].min = val;
                        /* Check maximum */
                        if ( val > dstats->dims[j].max )
                                dstats->dims[j].max = val;
                        /* Add to sum */
                        dstats->dims[j].sum += val;
                }
                /* Advance to next point */
                pt.data += schema->size;
        }

//      printf("pc_patch_uncompressed_compute_stats 2:  %d x %d %li\n",  pa->npoints, schema->ndims, micros_since_epoch2());
        pa->stats = pc_stats_new_from_dstats(pa->schema, dstats);
//      printf("pc_patch_uncompressed_compute_stats 3: %d x %d %li\n",  pa->npoints, schema->ndims, micros_since_epoch2());
        pc_dstats_free(dstats);
	printf("Serial time %lf\n", (micros_since_epoch2()-start)/1000000.);
        return PC_SUCCESS;
}





int
pc_patch_uncompressed_compute_stats(PCPATCH_UNCOMPRESSED *pa)
{
	uint64_t start =  micros_since_epoch2();
	const PCSCHEMA *schema = pa->schema;
	int tt, i, j;
	PCDOUBLESTATS *dstats = pc_dstats_new(pa->schema->ndims);
	if ( pa->stats )
		pc_stats_free(pa->stats);

	/* Point on stack for fast access to values in patch */
	PCPOINT pt[NTHREADS];
	int count[NTHREADS];
	for(tt=0; tt<NTHREADS; ++tt){
		pt[tt].readonly = PC_TRUE;
		pt[tt].schema = schema;
		count[tt] = 0;
	}
	//pt.data = pa->data;

	/* We know npoints right away */
	dstats->npoints = pa->npoints;

	//printf("pc_patch_uncompressed_compute_stats %d x %d %li\n",  pa->npoints, schema->ndims, micros_since_epoch2());
	
	omp_set_dynamic(0);
	omp_set_num_threads(NTHREADS);
	

// 	PCDOUBLESTATS **dstats_arr = (PCDOUBLESTATS**) malloc(sizeof(PCDOUBLESTATS*)*NTHREADS);
 	PCDOUBLESTATS *dstats_arr[NTHREADS];
	for(tt=0; tt<NTHREADS; ++tt){
		dstats_arr[tt] = pc_dstats_new(pa->schema->ndims);
	}



	int t, total=0, jj, ii;
	double val;
	#pragma omp parallel  shared(schema, dstats, dstats_arr, pt, pa, count) private(t, total, jj, ii, val)
	{
        total = 0;	
	t = omp_get_thread_num();	
	//printf("Starting Thread %d\n", t);
	//fflush(stdout);
	#pragma omp for private(val,t)
	for (ii = 0; ii < pa->npoints; ii++ )
	{
		t = omp_get_thread_num();
//		printf("For 1 %d %d\n", omp_get_thread_num(), total);
		count[t]++;
		total++;
		pt[t].data = pa->data + (schema->size*ii);
//		printf("Thread %i %i\n", t, i);
//		fflush(stdout);
		for (jj = 0; jj < schema->ndims; jj++ )
		{
			pc_point_get_double(&pt[t], schema->dims[jj], &val);
			/* Check minimum */
			if ( val < dstats_arr[t]->dims[jj].min ){
				dstats_arr[t]->dims[jj].min = val;
			}
			/* Check maximum */
			if ( val > dstats_arr[t]->dims[jj].max ){
				dstats_arr[t]->dims[jj].max = val;
			}
			/* Add to sum */
			dstats_arr[t]->dims[jj].sum += val;
		}
		/* Advance to next point */
	}
	//printf("Total %d %d\n", t, total);
	}
	
//	printf("Fim paralelo\n");
//	fflush(stdout);
	for(tt=0;tt<NTHREADS; ++tt){
//		printf("Reduce %d %d\n", tt, count[tt]);
//		fflush(stdout);
	 	for (j = 0; j < schema->ndims; j++ )
                {
                        /* Check minimum */
                        if ( dstats_arr[tt]->dims[j].min < dstats->dims[j].min ){
                                dstats->dims[j].min = dstats_arr[tt]->dims[j].min;
                        }
                        /* Check maximum */
                        if ( dstats_arr[tt]->dims[j].max > dstats->dims[j].max ){
                                dstats->dims[j].max = dstats_arr[tt]->dims[j].max;
                        }
                        /* Add to sum */
                        dstats->dims[j].sum += dstats_arr[tt]->dims[j].sum;
                }
	}

//	printf("Free\n");
//	fflush(stdout);
	for(tt=0;tt<NTHREADS; ++tt){
		pc_dstats_free(dstats_arr[tt]);
	}

//	printf("pc_patch_uncompressed_compute_stats 2:  %d x %d %li\n",  pa->npoints, schema->ndims, micros_since_epoch2());
	pa->stats = pc_stats_new_from_dstats(pa->schema, dstats);
//	printf("pc_patch_uncompressed_compute_stats 3: %d x %d %li\n",  pa->npoints, schema->ndims, micros_since_epoch2());
	pc_dstats_free(dstats);
	printf("Parallel time %lf\n", (micros_since_epoch2()-start)/1000000.);
//	fflush(stdout);
	return PC_SUCCESS;
}

size_t
pc_stats_size(const PCSCHEMA *schema)
{
	return 3*schema->size;
}



