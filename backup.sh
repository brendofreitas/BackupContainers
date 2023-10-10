#!/bin/bash



echo "##############################################################################################"
echo "##############   ##############   ##############   ##        ##   ##        ##   ############"
echo "##          ##   ##          ##   ##               ##      ##     ##        ##   ##        ##"
echo "##          ##   ##          ##   ##               ##    ##       ##        ##   ##        ##"
echo "##############   ##############   ##               ########       ##        ##   ############"
echo "##          ##   ##          ##   ##               ##    ##       ##        ##   ##"
echo "##          ##   ##          ##   ##               ##      ##     ##        ##   ##"
echo "##############   ##          ##   ##############   ##        ##   ############   ##"
echo "##############################################################################################"
echo "Olá! Bem-vindo ao Backup de Container Brendo."
echo "Este script permite que você faça backup de contêineres Docker de forma fácil."
echo "##############################################################################################"
echo "##############################################################################################"


echo "Escolha uma opção:"
echo "1 - Backup"
echo "2 - Restauração"
read -p "Digite o número da opção desejada: " OPCAO

case $OPCAO in
    1) # Backup
        read -p "Por favor, digite o nome do volume Docker que deseja fazer backup: " VOLUME_NAME
        VOLUME_NAME=$(echo "$VOLUME_NAME" | tr -d '[:space:]') # Remove espaços em branco

        # Define o nome do arquivo de backup com base na data atual e no nome do volume
        CURRENT_DATE=$(date +"%Y-%m-%d")
        BACKUP_FILE="./$VOLUME_NAME-$CURRENT_DATE.tar.gz"

        # Cria o contêiner temporário para o backup
        docker run -it --name meu_container -v $VOLUME_NAME:/volume_data -v $(pwd):/backup busybox:latest sh -c "if [ ! -d '/backup' ]; then mkdir /backup; fi && tar -czvf /backup/$BACKUP_FILE -C /volume_data . && exit"
        docker rm meu_container

        # Verifica se o backup foi criado com sucesso e exibe uma mensagem
        if [ -f "$BACKUP_FILE" ]; then
            echo "Backup do volume Docker $VOLUME_NAME criado com sucesso em ./$BACKUP_FILE"
        else
            echo "Erro ao criar backup do volume Docker $VOLUME_NAME"
        fi
        ;;
    2) # Restauração
        read -p "Por favor, digite o nome do arquivo de backup que deseja restaurar: " BACKUP_FILE
        BACKUP_FILE=$(echo "$BACKUP_FILE" | tr -d '[:space:]') # Remove espaços em branco

        read -p "Por favor, digite o nome do volume Docker que deseja fazer restaurar: " VOLUME_NAME
        VOLUME_NAME=$(echo "$VOLUME_NAME" | tr -d '[:space:]') # Remove espaços em branco

        docker run -it --name meu_container -v $VOLUME_NAME:/volume_data -v $(pwd):/backup busybox:latest sh -c "cd /backup && tar -xzvf $BACKUP_FILE -C /volume_data && exit"
        docker rm meu_container

        # docker run --rm -v $VOLUME_NAME:/volume_data -v $(pwd):/backup busybox:latest sh -c "tar -xzvf /backup/$BACKUP_FILE -C /volume_data"

        echo "Restauração concluída com sucesso no contêiner $CONTAINER_NAME."
        ;;
    *)
        echo "Opção inválida. Saindo do script."
        ;;
esac
