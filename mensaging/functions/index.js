'use strict';

const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendFollowerNotification = functions.database.ref('smart_home/json/comodos/{comodo}/sensores/{sensor}/valor')
    .onWrite(async (change, context) => {
     
     const beforeData = change.before.val();  
     const afterData = change.after.val();    

     if (beforeData === afterData) {
         return null;
     }

     const comodo = context.params.comodo;
     const sensor = context.params.sensor;
     const valor = afterData; 
     const listaSensoresAlerta = ['presenca','temperatura', 'umidade' ];

     if(!listaSensoresAlerta.includes(sensor)){
        return null;
     }
    let msgAlerta = "";
    let titleAlerta = "";
    if(sensor == 'presenca' && valor == 1){
      const ref = await functions.database.ref('smart_home/json/ausente');
      ref.on('ausente', snapshot => {
        const value = snapshot.val(); 
        if(value){
            titleAlerta = "🚨 Alerta de Presença na Sala";
            msgAlerta = "Foi detectado movimento na sala, indicando que há uma pessoa presente. Por favor, verifique se está tudo em ordem e tome as ações necessárias";
        }
    });
    }else if(Math.abs(beforeData - afterData)  > 20){
        if(sensor == 'temperatura'){
            titleAlerta = "🌡️ Alerta: Mudança Abrupta de Temperatura";
            msgAlerta = `A temperatura no cômodo ${comodo} mudou rapidamente. Verifique o ambiente para garantir conforto e segurança.`;
        }else{
          titleAlerta = "💧 Alerta: Mudança Abrupta de Umidade";
          msgAlerta = `A umidade no cômodo ${comodo} sofreu uma alteração significativa em um curto período de tempo. Verifique o ambiente para garantir que tudo esteja em ordem.`;
        }
    }
     
     const message = {
         notification: {
             title: titleAlerta,
             body: msgAlerta,
         },
         topic: 'alerta',  
     };

     return admin.messaging().send(message)
         .then((response) => {
             console.log('Notificação enviada com sucesso:', response);
             return null;
         })
         .catch((error) => {
             console.log('Erro ao enviar notificação:', error);
             return null;
         });
    });
