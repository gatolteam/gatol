import requests
import json
import inspect
import random

########################
### GLOBAL VARIABLES ###
########################


# SERVER = 'http://localhost:3000'
SERVER = 'https://calm-garden-9078.herokuapp.com'
TEST = ""
FILEPATH = 'C://Users//Aspire//Documents//Book1.csv'


########################
### HELPER FUNCTIONS ###
########################

def delete_account(idn, email, password):
    # get verification code
    r = requests.get(SERVER + '/api/students/' + str(idn), timeout=200)
    if r.status_code != 200:
        raise ValueError("failed GET request "+ str(r.json()['errors'])+ str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    #verify
    headers = {'Authorization':token}
    r = requests.post(SERVER + '/api/trainers/confirm', headers=headers, timeout=20)
    if r.status_code != 200:
        raise ValueError("verification failed " + str(r.status_code))

    # create new session (logging in)
    payload = {'email':email,
               'password':password}
    r = requests.post(SERVER + '/api/sessions', json=payload, timeout=200)

    if r.status_code != 200:
        raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    # delete account
    headers = {'Authorization':token}
    r = requests.delete(SERVER + '/api/trainers', headers=headers)

    if r.status_code != 204:
        raise ValueError("failed to delete account " + str(r.status_code))

    return True


def delete_account_student(idn, email, password):
    # get verification code
    r = requests.get(SERVER + '/api/students/' + str(idn), timeout=20)
    if r.status_code != 200:
        raise ValueError("failed GET request " + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    #verify
    headers = {'Authorization':token}
    r = requests.post(SERVER + '/api/students/confirm', headers=headers, timeout=20)
    if r.status_code != 200:
        raise ValueError("verification failed " + str(r.status_code))

    # create new session (logging in)
    payload = {'email':email,
               'password':password}
    r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

    if r.status_code != 200:
        raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    # delete account
    headers = {'Authorization':token}
    r = requests.delete(SERVER + '/api/students', headers=headers)

    if r.status_code != 204:
        raise ValueError("failed to delete account " + str(r.status_code))

    return True



def verify_and_login(idn, email, password):

    # get verification code
    r = requests.get(SERVER + '/api/trainers/' + str(idn), timeout=20)
    if r.status_code != 200:
        raise ValueError("failed GET request " + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    #verify
    headers = {'Authorization':token}
    r = requests.post(SERVER + '/api/trainers/confirm', headers=headers, timeout=20)
    if r.status_code != 200:
        raise ValueError("verification failed " + str(r.status_code))

    # create new session (logging in)
    payload = {'email':email,
               'password':password}
    r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

    if r.status_code != 200:
        raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()

    return token


def verify_and_login_student(idn, email, password):

    # get verification code
    r = requests.get(SERVER + '/api/students/' + str(idn), timeout=20)
    if r.status_code != 200:
        raise ValueError("failed GET request " + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()
            
    #verify
    headers = {'Authorization':token}
    r = requests.post(SERVER + '/api/students/confirm', headers=headers, timeout=20)
    if r.status_code != 200:
        raise ValueError("verification failed " + str(r.status_code))

    # create new session (logging in)
    payload = {'email':email,
               'password':password}
    r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

    if r.status_code != 200:
        raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

    token = r.json()['auth_token']
    token = token.encode()

    return token
    


def random_email():
    return 'a' + str(random.randint(0,9999999)) + '@hi.edu'







#############
### TESTS ###
#############

### write tests as a method in GatolTest
class GatolTest:

    

    # test 24
    @classmethod
    def test024_trainer_upload_csv(self):
        try:
            email = str(random.randint(0,9999999)) + '@hi.edu'
            
            # post
            payload = {'email':email,
                       'username':'test001',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed POST request " + str(r.status_code))

            idn = r.json()['id']


            # create new session (logging in)
            payload = {'email':email,
                       'password':'password1'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=200)

            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

            token = r.json()['auth_token']
            token = token.encode()



            # upload csv
            headers = {'Authorization':token}
            files = {'file': ('Book1.csv', open(FILEPATH, 'rb'))}
            r = requests.post(SERVER + '/api/question_sets/import', headers=headers, files=files)

            if r.status_code > 300:
                raise ValueError("failed to upload csv " + str(r.json()))






            

            return (True, "")

        except ValueError as e:
            return (False, str(e))




### DO NOT CHANGE UNDERTHIS LINE ###
if __name__ == '__main__':
    print("Gatol API tests")
    print("***")
    test_list = inspect.getmembers(GatolTest, predicate=inspect.ismethod)

    if TEST != "":
        new_list = []
        for test in test_list:
            if test[0].startswith(TEST):
                new_list.append(test)
        test_list = new_list
        
    index = 0
    num_pass = 0
    for test in test_list:
        index += 1
        result = test[1]()
        if result[0]:
            print 'PASSED {1}'.format(index, test[0])
            num_pass += 1
        else:
            print 'FAILED {1} ::: {2}'.format(index, test[0], result[1])
    print("***")
    print(str(num_pass) + "/" + str(len(test_list)) + " tests passed")
        
                         
