@isTest
global class QB_QuickBooksServiceMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
       // String body = generateResponseBody();
      //  res.setBody(body);
        res.setStatusCode(200);
        return res;
        
        
       /* Test.setMock(HttpCalloutMock.class, new ());
        Test.startTest();
       
        Test.stopTest();*/
    }
    
}