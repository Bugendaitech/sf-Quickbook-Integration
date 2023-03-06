@RestResource(UrlMapping='/testingSF/*')
global class RestResourceTesting {

    @HttpPost
    global static void method1(){
        system.debug('testtttt');
    }
}