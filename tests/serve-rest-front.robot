# *** Settings ***
# Resource          ../resources/serve-rest-front.resource
# Suite Setup       Cadastrar Usuário e Logar
# Suite Teardown    Close Browser    ALL

# *** Test Cases ***
# Login com sucesso Serverest-front
#     [Tags]    login_sucesso
#     Abrir o navegador
#     Ir para o site Serve Rest Front
#     Preencher os dados do novo usuario e cadastrar
#     Conferir Usuario Cadastrado com sucesso

# Desafio: Conferir se o novo usuário é mostrado na listagem de usuários
#     [Tags]    lista_usuario
#     Abrir o site Serve Rest Front Logado
#     Acessar a Lista de usuários
#     Conferir que o usuário aparece na listagem

# Desafio 2: cadastrar novo produto e validar que ele aparece na listagem
#     [Tags]    cadastrar_novo_produto
#     Abrir o site Serve Rest Front Logado
#     Cadastrar um novo produto
#     Conferir que o produto aparece na listagem

# Exemplo utilizando requisições HTTP
#     [Tags]    logar_via_Api
#     Abrir o Navegador
#     Ir para o site Serve Rest Front
#     Logar com o usuário cadastrado via API

# Exemplo utilizando o Storage Armazenado no Contexto
#     [Tags]    logar_com_storage
#     Abrir o site Serve Rest Front Logado
#     Acessar a Lista de usuários