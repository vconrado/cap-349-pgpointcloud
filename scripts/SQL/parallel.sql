CREATE OR REPLACE FUNCTION PC_Summary2(p pcpatch)
    RETURNS text AS '/home/vitor/cap-349-pgpointcloud/src/pointcloud/pointcloud-build/pgsql/pointcloud-1.1', 'pcpatch_summary'
    LANGUAGE 'c' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION _PC_PatchStat2(p pcpatch, statno int)
            RETURNS pcpoint AS '/home/vitor/cap-349-pgpointcloud/src/pointcloud/pointcloud-build/pgsql/pointcloud-1.1', 'pcpatch_get_stat'
        LANGUAGE 'c' IMMUTABLE STRICT;


CREATE OR REPLACE FUNCTION pcpatch_agg_final_pcpatch2 (pointcloud_abs)
        RETURNS pcpatch AS '/home/vitor/cap-349-pgpointcloud/src/pointcloud/pointcloud-build/pgsql/pointcloud-1.1', 'pcpatch_agg_final_pcpatch'
        LANGUAGE 'c';

CREATE OR REPLACE FUNCTION pcpatch_agg_transfn2 (pointcloud_abs, pcpatch)
        RETURNS pointcloud_abs AS '/home/vitor/cap-349-pgpointcloud/src/pointcloud/pointcloud-build/pgsql/pointcloud-1.1', 'pointcloud_agg_transfn'
        LANGUAGE 'c';


 CREATE AGGREGATE PC_Union2 (
	BASETYPE = pcpatch,
	SFUNC = pcpatch_agg_transfn2,
	STYPE = pointcloud_abs,
	FINALFUNC = pcpatch_agg_final_pcpatch2
);