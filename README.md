# Smart Home

Este projeto é uma implementação de uma **Smart Home** utilizando **Flutter**, **ESP32**, **Arduino** e **Firebase**. O objetivo é integrar sensores e atuadores em uma maquete de uma casa, com controle através de um aplicativo mobile. A comunicação entre os dispositivos é feita por meio de **UART** e dados são armazenados e sincronizados em tempo real usando **Firebase Realtime Database**.

## Tecnologias Utilizadas

- **Flutter**: Framework para a criação da aplicação mobile.
- **ESP32**: Microcontrolador responsável pela coleta e envio dos dados dos sensores.
- **Arduino**: Microcontrolador utilizado para alimentar o sensor de presença e controlar o display LDC.
- **Firebase**:
  - **Firebase Realtime Database**: Para armazenamento e sincronização de dados em tempo real.
  - **Firebase Functions**: Para manipulação de eventos no backend.
  - **Firebase Messaging**: Para enviar notificações em tempo real.
  - ** Firebase Auth**: Para autenticação do usuário.
- **UART**: Protocolo de comunicação entre o **ESP32** e os **Arduinos**.
- **Sensores**:
  - Sensores de presença, umidade, temperatura e luz.
- **Atuadores**:
  - LEDs, motor, servo motor, display LDC.

## Funcionalidades

- **Controle de Dispositivos**: Controle de LEDs, motores e outros atuadores em tempo real.
- **Sensores**: Monitoração de presença, temperatura, umidade e luz.
- **Notificações**: Notificações em tempo real quando um evento é acionado, como a mudança de temperatura ou presença de pessoas.
- **Autenticação**: Proteção do sistema com **Firebase Authentication**.
- **Geolocalização**: Identificação da localização do usuário para automatizar ações quando ele estiver em casa ou fora.
- **Rotinas Automatizadas**: Programação de ações, como acender luzes ou abrir janelas automaticamente quando o usuário chega em casa.

## Como Rodar o Projeto

### 1. **Configuração do Firebase**

- Crie um projeto no [Firebase](https://firebase.google.com/).
- Ative o **Realtime Database**, **Firebase Auth** ,  **Firebase Functions** e **Firebase Messaging**.
- Baixe as credenciais do Firebase e configure-as no seu aplicativo Flutter.

### 2. **Configuração do ESP32**

- Para o **ESP32**, você deve configurar o ambiente de desenvolvimento com a IDE Arduino ou **PlatformIO**.
- Carregue o código que coleta os dados dos sensores e os envia para o Firebase.
- Configure dois **ESP32** para enviar e receber dados do Firebase.

### 3. **Configuração do Arduino**

- Utilize dois **Arduinos** para alimentar o sensor de presença (não compatível com 3,3V do ESP32) e controlar o display LDC.
- A comunicação entre o ESP32 e os Arduinos é feita via **UART**.

### 4. **Aplicativo Flutter**

- Clone o repositório.
- Instale as dependências com o comando:
  
  ```bash
  flutter pub get
