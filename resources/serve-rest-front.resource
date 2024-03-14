*** Settings ***
Library    Browser
# ...        timeout=00:00:05
# ...        enable_presenter_mode=${true} 

Library    FakerLibrary
Library    DateTime

*** Variables ***
${BROWSER}            chromium
${HEADLESS}           ${false}
${SITE_SERVE_REST}    https://front.serverest.dev/login


*** Keywords ***
Abrir o Navegador
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}

    ${TRACE_NAME}    FakerLibrary.Uuid 4
    ${NOW}    Get Current Date    result_format=%d-%m-%Y_%H%M%S    

    New Context    viewport={'width': 1200, 'height': 800}
    # ...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    # ...            recordVideo={'dir':'${OUTPUT_DIR}/evidencies/videos/${NOW}'}


Ir para o site Serve Rest Front
    New Page    url=${SITE_SERVE_REST}
    ${title}    Get Title                 ==    Front - ServeRest
    Log         ${title}

Preencher os dados do novo usuario e cadastrar
    # Record Selector
    # Click    css=.btn-link

    # Busca por texto
    # Click    text="Cadastre-se"
    Click    css=a[data-testid='cadastrar']

    ${EMAIL}             FakerLibrary.Email
    Set Test Variable    ${EMAIL}
    ${NOME}              FakerLibrary.Name
    Set Test Variable    ${NOME}

    Fill Text         css=input#nome             ${NOME}
    Fill Text         css=input#email            ${EMAIL}
    Fill Text         css=input#password         123456
    Check Checkbox    css=input#administrador
    # normal selector
    # Click               css=button[data-testid='cadastrar']

    # Cascade selector
    Click    xpath=//*[@id="root"]//button >> text="Cadastrar"

    Take Screenshot

Conferir Usuario Cadastrado com sucesso
    Wait For Elements State    h1                              visible
    Get Text                   h1                              ==          Bem Vindo ${NOME}
    Get Element States         button[data-testid='logout']    validate    value & visible

Cadastrar um novo usuario
    Abrir o Navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuario e cadastrar
    Conferir Usuario Cadastrado com sucesso
Acessar a Lista de usuários
    Click                 css=a[data-testid='listarUsuarios']
    Get Element States    h1                                     validate    visible
    Get Text              h1                                     ==          Lista dos usuários
    Take Screenshot

Conferir que o usuário aparece na listagem
    ${elemento}           Get Table Cell Element    xpath=//table[@class="table table-striped"]    "Nome"     "${EMAIL}"
    Get Text              ${elemento}               ==    ${NOME}
    Scroll To Element     ${elemento}
    Highlight Elements    ${elemento}
    Take Screenshot

Cadastrar um novo produto
    ${NUMBER}               FakerLibrary.Random Number    digits=3
    ${NOME_PRODUTO}         Set Variable                  Product No_${NUMBER}
    ${PRECO_PRODUTO}        FakerLibrary.Random Number    digits=3
    ${PRECO_PRODUTO}        Convert to String             ${PRECO_PRODUTO}
    ${DESCRICAO_PRODUTO}    FakerLibrary.Text
    ${QTDE_PRODUTO}         FakerLibrary.Random Number    digits=2
    ${QTDE_PRODUTO}         Convert to String             ${QTDE_PRODUTO}

    Set Test Variable    ${NOME_PRODUTO} 
    Set Test Variable    ${PRECO_PRODUTO}
    Set Test Variable    ${QTDE_PRODUTO}

    Click        css=a[data-testid='cadastrarProdutos']
    Fill Text    css=input[data-testid='nome']             ${NOME_PRODUTO}
    Fill Text    css=input[data-testid='preco']            ${PRECO_PRODUTO}
    Fill Text    css=textarea[data-testid='descricao']     ${DESCRICAO_PRODUTO}
    Fill Text    css=input[data-testid='quantity']         ${QTDE_PRODUTO}

    Click    css=button[data-testid='cadastarProdutos']



Conferir que o produto aparece na listagem
    Get Text                h1                        ==                                             Lista dos Produtos
    ${elemento}             Get Table Cell Element    xpath=//table[@class="table table-striped"]    "Nome"                "${NOME_PRODUTO}"
    ${elementPreco}         Get Table Cell Element    xpath=//table[@class="table table-striped"]    "Preço"               "${NOME_PRODUTO}"
    ${elementQuantidade}    Get Table Cell Element    xpath=//table[@class="table table-striped"]    "Quantidade"          "${NOME_PRODUTO}"
    Get Text                ${elemento}               ==                                             ${NOME_PRODUTO}
    Get Text                ${elementPreco}           ==                                             ${PRECO_PRODUTO}
    Get Text                ${elementQuantidade}      ==                                             ${QTDE_PRODUTO}
    Scroll To Element       ${elemento}
    Highlight Elements      ${elemento}
    Take Screenshot


Criar usuário via API
    ${EMAIL}    FakerLibrary.Email
    Set Suite Variable    ${EMAIL}
    ${NOME}              FakerLibrary.Name
    Set Suite Variable    ${NOME}

    ${resposta}    Http    url=https://serverest.dev/usuarios
    ...            method=POST
    ...            body={"nome": "${NOME}","email": "${EMAIL}","password": "123456","administrador": "true"}

    Should Be Equal As Integers    ${resposta["status"]}    201

Logar com o usuário cadastrado via API
    ${resposta}    Http    url=https://serverest.dev/login
    ...                    method=POST
    ...                    body={"email": "${EMAIL}", "password": "123456"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userNome     ${NOME}
    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}

    Go To    https://front.serverest.dev/admin/home

    Take Screenshot

Cadastrar Usuário e Logar
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}
    
    New Page           url=${SITE_SERVE_REST}
    Criar usuário via API
    Logar com o usuário cadastrado via API
    ${STORAGE_FILE}    Save Storage State
    Set Suite Variable    ${STORAGE_FILE}

Abrir o site Serve Rest Front Logado
        New Context    viewport={'width': 1200, 'height': 800}
        ...            storageState=${STORAGE_FILE}
        
        New Page        url=https://front.serverest.dev/admin/home
        Get Text        h1    ==    Bem Vindo ${NOME}
        Take Screenshot
    