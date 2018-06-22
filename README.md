# desafio-carros

## Apresentação da Aplicação

Desafio desenvolvido para a empresa BRQ. O aplicativo carrega uma lista com as opções de carros, uma tela de detalhes e uma cesta de compras. O sistema permite adicionar e remover carros e finalizar a compra. Salvando os dados no banco Realm local do aplicativo. Cliente inicialmente recebe R$ 100.000,00 (cem mil reais) em conta para comprar carros. Aplicativo desenvolvido com com arquitetura MVVM.

## Requerimento/Dependências

* [COCOAPODS](https://cocoapods.org) - The web framework used
* [Alamofire](https://github.com/Alamofire/Alamofire) - Dependency Management
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) - Dependency Management
* [PromisseKit](https://github.com/mxcl/PromiseKit) - Dependency Management
* [Realm](https://github.com/realm) - Dependency Management
* [Realm-Cocoa](https://github.com/realm/realm-cocoa) - Dependency Management
* [RealmSwift](https://github.com/realm/realm-cocoa/tree/master/RealmSwift) - Dependency Management
* [SDWebImage](https://github.com/rs/SDWebImage) - Dependency Management

## Como Começar

- Desafio feito em linguagem Swift.
- Configuração de rotas e constantes através do arquivo: Constants.swift
- Dados armazenados em um Banco de Dados Realm local.

## Lançamentos Principais

## Como usar

## Carregando Lista de Carros

Ao abrir o aplicativo é feito o download dos carros da API. Os carros são carregados em uma tableView.

<a href="https://imgflip.com/gif/2cpj6r"><img src="https://i.imgflip.com/2cpj6r.gif" title="made at imgflip.com"/></a>

## Registo de Clientes

Após carregar os carros, o cliente será criado automaticamente e uma mensagem irá aparecer informando que o cliente foi registrado. O cliente recebe inicialmente um saldo de R$100.000,00 (cem mil reais) para efetuar compras. Para configurar os dados do cliente, é necessário editar o arquivo: Constants.swift

Campos para teste de registro:

- let NAME_CLIENT = "Jose"
- let EMAIL_CLIENT = "jose@gmail.com"
- let SALE_CLIENT = 100000.0

## Tela de Adição e Remoção de carros

Aqui o cliente poderá adicionar e remover carros na cesta de compras.

<a href="https://imgflip.com/gif/2cpjd2"><img src="https://i.imgflip.com/2cpjd2.gif" title="made at imgflip.com"/></a>

Adicionando carro:

<a href="https://imgflip.com/gif/2cpjla"><img src="https://i.imgflip.com/2cpjla.gif" title="made at imgflip.com"/></a>

Aqui o cliente poderá remover carros na cesta de compras.

Removendo carro:

<a href="https://imgflip.com/gif/2cpk26"><img src="https://i.imgflip.com/2cpk26.gif" title="made at imgflip.com"/></a>

## Tela de Cesta de Compras

<a href="https://imgflip.com/gif/2cpk7t"><img src="https://i.imgflip.com/2cpk7t.gif" title="made at imgflip.com"/></a>

## Lista de carros

Após adicionar carros na cesta de compras, um ícone de carrinho irá aparecer no topo da tela.

<a href="https://imgflip.com/gif/2cpkdg"><img src="https://i.imgflip.com/2cpkdg.gif" title="made at imgflip.com"/></a>

## Chamando da Cesta de Compras

<a href="https://imgflip.com/gif/2cpki5"><img src="https://i.imgflip.com/2cpki5.gif" title="made at imgflip.com"/></a>

## Excluindo Cesta de Compras

É possível remover a Cesta de Compras inteira clicando no ícone de exclusão e confirmando.

<a href="https://imgflip.com/gif/2cpkni"><img src="https://i.imgflip.com/2cpkni.gif" title="made at imgflip.com"/></a>

## Confirmação de Pagamento

Clicando no botão para confirmação de pagamento, o pagamento será efetuado.

<a href="https://imgflip.com/gif/2cpl5l"><img src="https://i.imgflip.com/2cpl5l.gif" title="made at imgflip.com"/></a>

## Transações de Compra

Após o pagamento as transações de compra ficam salvas no banco Realm.

## Mensagens do Aplicativo

Algumas mensagens podem ocorrer durante a navegação do aplicativo.

- Aviso de Cliente criado com sucesso.
- Aviso de saldo insuficiente.
- Aviso de Confirmação de exclusão da cesta de compras.
- Aviso de Confirmação de pagamento.

## Status do Código

- Enviado.

## Licença

Este projeto está licenciado sob a licença MIT - Consulte LICENÇA para obter detalhes.

## Créditos

* **Luís Felipe Tapajós** - *Initial work* - [lftapajos](https://github.com/lftapajos)

