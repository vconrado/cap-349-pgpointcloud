SELECT  p.*
FROM    pg_catalog.pg_namespace n
JOIN    pg_catalog.pg_proc p
ON      p.pronamespace = n.oid
WHERE   n.nspname = 'public' order by p.proname

"pcpatch_summary"

select * from pg_catalog.pg_proc where proname = 'pc_union2';

update set probin = "/home/vitor/cap-349-pgpointcloud/src/pointcloud/pointcloud-build/pgsql/pointcloud-1.1.so" where proname = 'pc_summary';

"$libdir/pointcloud-1.1"


select PC_Union2(pa) from "HUML6510C8920";

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


DROP AGGREGATE PC_Union(pcpatch);

        CREATE AGGREGATE PC_Union2 (
                BASETYPE = pcpatch,
                SFUNC = pcpatch_agg_transfn2,
                STYPE = pointcloud_abs,
                FINALFUNC = pcpatch_agg_final_pcpatch2
        );

        CREATE OR REPLACE AGGREGATE PC_Union (
                BASETYPE = pcpatch,
                SFUNC = pcpatch_agg_transfn,
                STYPE = pointcloud_abs,
                FINALFUNC = pcpatch_agg_final_pcpatch
        );

        1472339629886757-1472339651878899


select PC_AsText(_PC_PatchStat2(pa, 1)) from "UML6510C8920";


select _PC_PatchStat2(pa, 2) from patches;



 select PC_Summary2(PC_Union2(pa)) from "UML6510C8920";

 select PC_Summary(PC_Union(pa)) from "UML6510C8920";