 ConvertWallet

🎓 Projeto de TCC - Graduação em Engenharia de Software - UniCesumar, Maringá

Este repositório contém o projeto ConvertWallet, desenvolvido como Trabalho de Conclusão de Curso (TCC) para a graduação em Engenharia de Software na UniCesumar, campus de Maringá. O ConvertWallet é um aplicativo móvel que permite a conversão de moedas e o gerenciamento de uma carteira virtual com cotações em tempo real. O aplicativo foi desenvolvido utilizando o framework Flutter, visando compatibilidade com dispositivos Android e iOS.

📋 Objetivo do Projeto

O objetivo do ConvertWallet é fornecer uma solução prática e intuitiva para a conversão de moedas internacionais, permitindo que os usuários acompanhem as taxas de câmbio e gerenciem diferentes moedas de forma rápida e eficaz. O projeto visa facilitar a gestão financeira de usuários que lidam com múltiplas moedas, integrando uma API pública de cotações e utilizando SQLite para armazenamento local.

🚀 Funcionalidades

✔️ Consulta de Cotações: Visualização de cotações em tempo real de diversas moedas. Os usuários podem selecionar uma moeda de referência e visualizar as taxas de câmbio atualizadas.
✔️ Conversão de Moedas: Permite ao usuário converter valores entre diferentes moedas com base nas taxas mais recentes.
✔️ Gerenciamento de Carteira Virtual: Adiciona e remove valores de diferentes moedas, mostrando o total atualizado em uma moeda de referência escolhida pelo usuário.
✔️ Persistência de Dados: Utiliza SQLite para armazenar as últimas cotações, permitindo o funcionamento do aplicativo mesmo offline.
✔️ Atualização Automática de Cotações: As taxas de câmbio são atualizadas automaticamente sempre que o aplicativo detecta uma conexão com a API.

🛠️ Arquitetura do Projeto

O ConvertWallet segue uma arquitetura MVVM adaptada, onde:

	•	View (Apresentação): Renderiza a interface gráfica e interage com o usuário. Inclui as telas de Cotações, Conversão e Carteira.
	•	Controller (Controle): Recebe as interações da View, solicita os dados ao Repository e aplica a lógica de negócios, salvando as informações no SQLite e no Singleton.
	•	Repository (Repositório): Faz a requisição dos dados à API de Cotações ou ao SQLite, converte os dados recebidos e os entrega ao Controller.
	•	DataSource (Fonte de Dados): Dividida em Data Search Remote (requisição à API de Cotações) e Data Search Local (requisição ao SQLite), garantindo que os dados estejam sempre disponíveis, tanto online quanto offline.
	•	Singleton: Armazena valores globais em memória, facilitando o compartilhamento de informações como cotações e a moeda de referência entre as diferentes partes do aplicativo.

🛠️ Tecnologias Utilizadas

	•	🐦 Flutter: Framework para desenvolvimento multiplataforma (Android e iOS).
	•	🎯 Dart: Linguagem de programação utilizada no Flutter.
	•	💾 SQLite: Para armazenamento local de dados e persistência offline.
	•	🌐 API REST: Para obter as taxas de câmbio em tempo real.

💡 Possíveis Melhorias Futuras

🔧 Implementação de mais funcionalidades de gerenciamento financeiro.
🚀 Publicação do aplicativo nas lojas (Google Play, App Store) após análise de custos relacionados ao uso da API de cotações.
🔍 Avaliação de alternativas de API para reduzir custos operacionais.

🏗️ Como Contribuir

	1.	Faça um fork do repositório.
	2.	Crie uma branch para suas alterações: git checkout -b minha-nova-feature
	3.	Faça as alterações necessárias e commit: git commit -m 'Adiciona nova feature'
	4.	Envie para a branch principal: git push origin minha-nova-feature
	5.	Abra um Pull Request e descreva as alterações propostas.
 
🧪 Como Testar a Aplicação

Para testar o aplicativo ConvertWallet, é necessário uma chave de API gratuita da Free Currency API. 

📜 Licença

Este projeto foi desenvolvido como parte do TCC e pode ser utilizado para fins educacionais.

Espero que tenha gostado dessa versão com alguns toques de estilo visual! Se precisar de algo mais, estou à disposição!
