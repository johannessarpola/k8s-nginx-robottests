# pull the latest official nginx image
FROM nginx:stable
# run docker service on HTTPS
EXPOSE 80
# copy the additional nginx configuration
COPY page/maintenance.html /usr/share/nginx/html/index.html
COPY page/maintenance.conf /etc/nginx/conf.d/maintanence.conf
# copy ssl pem 
#COPY domain.org.pem /etc/nginx/conf.d/domain.org.pem
# copy ssl key
#COPY domain.org.key /etc/nginx/conf.d/domain.org.key
# copy static maintanence

STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]