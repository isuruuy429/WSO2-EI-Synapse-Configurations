We can use enrich mediator to do slight modification to the request as well as the response. Through this we shall look how we can do a modification to the response using enrich mediator.

Invoke the proxy with the below payload. 

```
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.samples" xmlns:xsd="http://services.samples/xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:getQuote>
         <!--Optional:-->
         <ser:request>
            <!--Optional:-->
            <xsd:symbol>IBM</xsd:symbol>
         </ser:request>
      </ser:getQuote>
   </soapenv:Body>
</soapenv:Envelope>