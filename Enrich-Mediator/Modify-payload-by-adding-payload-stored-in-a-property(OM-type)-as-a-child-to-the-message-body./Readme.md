# Modify payload by adding payload stored in a property(OM type) as a child to the message body.

In this example, we store the following payload in a property called employeeInfo. 

```
<?xml version="1.0" encoding="UTF-8"?>
<employeeInfo>
   <employee>
      <firstName>Jacque</firstName>
      <lastName>Kallis</lastName>
      <team>EI</team>
   </employee>
   <employee>
      <firstName>Mark</firstName>
      <lastName>Boucher</lastName>
      <team>STL</team>
   </employee>
</employeeInfo>
```

But we need use only in xpath employeeInfo/employee tag. Therefore we extract the following part of element as $ctx:employeeInfo/employee

```
<employee>
      <firstName>Jacque</firstName>
      <lastName>Kallis</lastName>
      <team>EI</team>
   </employee>
   <employee>
      <firstName>Mark</firstName>
      <lastName>Boucher</lastName>
      <team>STL</team>
   </employee>
   ```