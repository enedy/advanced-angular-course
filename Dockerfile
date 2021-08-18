### Estágios do build ###

### Gera o build Angular ###
# imagem node... AS = (apelido do container)
FROM node:latest AS ng-builder
# Cria diretório app para colocar os arquivos
RUN mkdir -p /app 
# path de trabalho (onde irei trabalhar dentro do container)
WORKDIR /app
# Copia o arquivo package.json da minha aplicacao para a pasta "app"
# para que eu possa instalar todas as dependencias  através do comando "npm install" (consigo isso pois meu container roda uma imagem do node)
COPY package.json /app
RUN npm install --legacy-peer-deps
# Copia todos os dados da raiz para a pasta "app"
COPY . /app
# Vou rodar comando dentro do container, do tipo npm ($(npm bin)) 
# Gera o build para a versao de producao (ng build --prod)
RUN $(npm bin)/ng build --prod


### Sobe o código para o servidor NGINX (servidor leve de HTTP) com o app Angular ###
# imagem que vai virar um container
FROM nginx
# copiar o arquivo de configuracao do nginx para o container do nginx (FROM nginx) dentro da pasta /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf
# tudo o q tiver dentro da pasta app/dist/front-end eu vou jogar para a pasta usr/share/nginx/html (que esta dentro do container)
COPY --from=ng-builder /app/dist/front-end /usr/share/nginx/html

EXPOSE 80

### Comandos docker
# docker build -t meusprodutos .
#  -t (tag para nome do container )
#  . (esta na raiz do comando o arquivo dockerfile)

#docker run --name meusprodutos -d -p 8080:80 meusprodutos
# vou rodar o container chamado meusprodutos
# -d rodar o container de forma desatachada
# -p 8080:80 - estou na porta 8080 da minha maquina local conversando com a porta 80 do container