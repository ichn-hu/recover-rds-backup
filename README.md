
# Restore a MySQL in docker from RDS backup

1. obtain the backup from RDS management panel, make sure the backup filename has `_qp.xb` ending, put it into a directory, say `/home/dev/recover/backup`
2. obtain the docker image, either by build it yourself or download from dockerhub
   1. to build  
   ```
   # docker build -t rds-restorer .
   ```
3. start  
  ```
  # docker run -p 3308:3306 --name docker-restore -v /home/dev/recover/backup:/backup -d restorer
  ```

