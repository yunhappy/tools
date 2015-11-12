mysqldump -h127.0.0.1 -uroot -p123456 -d ese2-17100 > ese2db.xml --xml
sed -i 's/varchar(255)/char" Len="255/g' ese2db.xml 
sed -i 's/varchar(512)/char" Len="512/g' ese2db.xml 
sed -i 's/varchar(64)/char" Len="64/g' ese2db.xml
sed -i 's/bigint(20)/sint64/g' ese2db.xml 
sed -i 's/timestamp/sint64/g' ese2db.xml 
sed -i 's/int(11)/int/g' ese2db.xml   
sed -i 's/datetime/char" Len="255/g' ese2db.xml  
sed -i '/create_time/d' ese2db.xml
sed -i '/update_time/d' ese2db.xml
sed -i '/key Table/d' ese2db.xml
sed -i '/options Name/d' ese2db.xml
