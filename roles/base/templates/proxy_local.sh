export http_proxy=http://{{ hostvars[inventory_hostname]['ansible_host'] }}:8888
export https_proxy=http://{{ hostvars[inventory_hostname]['ansible_host'] }}:8888
export ftp_proxy=http://{{ hostvars[inventory_hostname]['ansible_host'] }}:8888
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export FTP_PROXY=$ftp_proxy
