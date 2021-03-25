FROM alpine/git as clone
WORKDIR /app
RUN git clone https://github.com/serp-ya/card-transfer.git /app

FROM node:lts AS development
WORKDIR /app
COPY --from=clone /app/*.json ./
RUN npm install
COPY --from=clone /app .
ENV REACT_APP_API_URL=
ENV PUBLIC_URL=.
CMD [ "npm", "start" ]

FROM development AS build
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY /nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]