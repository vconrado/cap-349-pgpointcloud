INSERT INTO pointcloud_formats (pcid, srid, schema) VALUES (3, 31980,
'<?xml version="1.0" encoding="UTF-8"?>
<pc:PointCloudSchema xmlns:pc="http://pointcloud.org/schemas/PC/1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <pc:dimension>
        <pc:position>1</pc:position>
        <pc:size>8</pc:size>
        <pc:description>X coordinate description</pc:description>
        <pc:name>X</pc:name>
        <pc:interpretation>floating</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>2</pc:position>
        <pc:size>8</pc:size>
        <pc:description>Y coordinate description</pc:description>
        <pc:name>Y</pc:name>
        <pc:interpretation>floating</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>3</pc:position>
        <pc:size>8</pc:size>
        <pc:description>Z coordinate description</pc:description>
        <pc:name>Z</pc:name>
        <pc:interpretation>floating</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>4</pc:position>
        <pc:size>2</pc:size>
        <pc:description>Intensity description</pc:description>
        <pc:name>Intensity</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>5</pc:position>
        <pc:size>1</pc:size>
        <pc:description>ReturnNumber description</pc:description>
        <pc:name>ReturnNumber</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>6</pc:position>
        <pc:size>1</pc:size>
        <pc:description>NumberOfReturns description</pc:description>
        <pc:name>NumberOfReturns</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>7</pc:position>
        <pc:size>1</pc:size>
        <pc:description>ScanDirectionFlag description</pc:description>
        <pc:name>ScanDirectionFlag</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>8</pc:position>
        <pc:size>1</pc:size>
        <pc:description>EdgeOfFlightLine description</pc:description>
        <pc:name>EdgeOfFlightLine</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>9</pc:position>
        <pc:size>1</pc:size>
        <pc:description>Classification description</pc:description>
        <pc:name>Classification</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>10</pc:position>
        <pc:size>1</pc:size>
        <pc:description>ScanAngleRank description</pc:description>
        <pc:name>ScanAngleRank</pc:name>
        <pc:interpretation>floating</pc:interpretation>
        <pc:scale>4</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>11</pc:position>
        <pc:size>1</pc:size>
        <pc:description>UserData description</pc:description>
        <pc:name>UserData</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>12</pc:position>
        <pc:size>2</pc:size>
        <pc:description>PointSourceId description</pc:description>
        <pc:name>PointSourceId</pc:name>
        <pc:interpretation>unsigned</pc:interpretation>
        <pc:scale>1</pc:scale>
    </pc:dimension>
    <pc:dimension>
        <pc:position>13</pc:position>
        <pc:size>8</pc:size>
        <pc:description>GpsTime description</pc:description>
        <pc:name>GpsTime</pc:name>
        <pc:interpretation>floating</pc:interpretation>
        <pc:scale>8</pc:scale>
    </pc:dimension>
    <pc:metadata>
        <Metadata name="compression">dimensional</Metadata>
    </pc:metadata>
    </pc:PointCloudSchema>');
