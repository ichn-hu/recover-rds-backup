#! /bin/bash
XB_DIR=/backup
DATA_DIR=/restore-data
mkdir -p $DATA_DIR

XB_FILE=$(ls $XB_DIR/*_qp.xb)
echo "using file $XB_FILE"

cat $XB_FILE | xbstream -x -v -C $DATA_DIR
xtrabackup --decompress --remove-original --target-dir=$DATA_DIR
xtrabackup --prepare --target-dir=$DATA_DIR
xtrabackup --datadir=/var/lib/mysql --copy-back --target-dir=$DATA_DIR
sed -i -E -e 's/^server_uuid=(.*)$/# server_uuid=\1/g'\
          -e 's/^master_key_id=(.*)$/# master_key_id=\1/g'\
          -e 's/^innodb_encrypt_algorithm=(.*)$/# innodb_encrypt_algorithm=\1/g'\
          -e 's/^\[mysqld\]$/\[mysqld\]\nlower_case_table_names=1/g' $DATA_DIR/backup-my.cnf
cat $DATA_DIR/backup-my.cnf
cp $DATA_DIR/backup-my.cnf /etc/mysql/conf.d
exec /entrypoint.sh mysqld "$@"

