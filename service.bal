import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;
import ballerina/sql;
import ballerina/log;

type isValid record {
    boolean valid;
    string nic;
};

type Person record {
    string nic;
    @sql:Column{name:"firstname"}   
    string firstName;
    @sql:Column{name:"lastname"}
    string lastName;

};

configurable string database = ?;

configurable string username = ?;

configurable string host = ?;

configurable int port = ?;

configurable string password = ?;

final mysql:Client mysqlEp = check new (host = host, user = username, database = database, port=port, password=password);

service / on new http:Listener(9090) {

    isolated resource function get checkNic/[string nic]() returns isValid|error? {

        Person|error queryRowResponse=mysqlEp->queryRow(`select * from nic_details where nic=${nic.trim()}`);

        if queryRowResponse is error{
            isValid result={
                valid: false,
                nic:nic
            };
            log:printInfo("Entered NIC is Invalid");
            return result;        }else{
            isValid result={
                valid: true,
                nic:nic
            };
            log:printInfo(result.toBalString());
            return result;
        }

    }
}

