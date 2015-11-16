import requests
import json
import inspect
import random

########################
### GLOBAL VARIABLES ###
########################


# SERVER = 'http://localhost:3000'
SERVER = 'https://calm-garden-9078.herokuapp.com'
TEST = "test024"
FILEPATH = 'Book1.csv'

########################
### HELPER FUNCTIONS ###
########################

def delete_account(idn, email, password):
    # get verification code
    r = requests.get(SERVER + '/api/trainers/' + str(idn), timeout=200)
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

    

    # test 1
    @classmethod
    def test001_trainer_create_show(self):
        try:
            email = str(random.randint(0,9999999)) + '@hi.edu'
            
            # post
            payload = {'email':email,
                       'username':'test1',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed POST request " + str(r.status_code))

            idn = r.json()['id']

            # get
            r = requests.get(SERVER + '/api/trainers/' + str(idn), timeout=20)
            if r.status_code != 200:
                raise ValueError("failed GET request " + str(r.status_code))

            return (True, "")

        except ValueError as e:
            return (False, str(e))


    # test 2
    @classmethod
    def test002_login_logout(self):
        try:
            email = str(random.randint(0,9999999)) + '@hi.edu'
            # create new account
            payload = {'email':email,
                       'username':'test2',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=200)
            if r.status_code != 201:
                raise ValueError("failed create account " + str(r.status_code))

            idn = r.json()['id']

            # get verification code
            r = requests.get(SERVER + '/api/trainers/' + str(idn), timeout=200)
            if r.status_code != 200:
                raise ValueError("failed GET request " + str(r.status_code))

            token = r.json()['auth_token']
            token = token.encode()

            #verify
            payload = {'email':'hi'}
            headers = {'Authorization': token}
            r = requests.post(SERVER + '/api/trainers/confirm', headers=headers, timeout=200)
            # r = requests.post(SERVER + '/api/trainers/confirm', timeout=200)
            
            if r.status_code != 200:
                raise ValueError("verification failed " + str(r.json()['errors']) + str(r.status_code))     

            
            # create new session (logging in)
            payload = {'email':email,
                       'password':'password3'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=200)

            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.status_code))

            token = r.json()['auth_token']
            token = token.encode()

            # log out
            r = requests.delete(SERVER + '/api/sessions/' + str(token), timeout=200)

            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))


            # try to delete account with old token - should fail

            headers = {'Authorization':token}
            r = requests.delete(SERVER + '/api/trainers', headers=headers, timeout=200)

            if r.status_code == 204:
                raise ValueError("delete account-should fail " + str(r.status_code))
            
            
            return (True, "")


        except ValueError as e:
            return (False, str(e))


    # test 3
    @classmethod
    def test003_create_verify_login_delete_account(self):
        try:

            # create new account
            payload = {'email':'test3@berkeley.edu',
                       'username':'user3',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']

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
            payload = {'email':'test3@berkeley.edu',
                       'password':'password3'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))

            token = r.json()['auth_token']
            token = token.encode()
            
            # delete account
            headers = {'Authorization':token}
            r = requests.delete(SERVER + '/api/trainers', headers=headers)

            if r.status_code != 204:
                raise ValueError("failed to delete account " + str(r.status_code))

            return (True, "")


        except ValueError as e:
            return (False, str(e))
        

    # test 4
    @classmethod
    def test004_error_if_email_exist(self):
        try:
            # create new account
            payload = {'email':'test4@berkeley.edu',
                       'username':'test4',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']
            

            # create new account with same email address - should be fail
            payload = {'email':'test4@berkeley.edu',
                       'username':'test4-2',
                       'password':'password4',
                       'password_confirmation':'password4'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account(idn, 'test4@berkeley.edu', 'password1'), "")

        except ValueError as e:
            return (False, str(e))


    # test 5
    @classmethod
    def test005_error_if_password_doesnt_match(self):
        try:
            # create new account
            payload = {'email':'test5@berkeley.edu',
                       'username':'test5',
                       'password':'password1',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code == 201:
                raise ValueError("password does not match but still created " + str(r.status_code))
            return (True, "")

        except ValueError as e:
            return (False, str(e))


    # test 6
    @classmethod
    def test006_loginerror_if_unverified(self):
        try:
            # create new account
            payload = {'email':'test6@berkeley.edu',
                       'username':'test6',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            # try to login before verification - should fail
            payload = {'email':'test6@berkeley.edu',
                       'password':'password3'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            return (delete_account(idn, 'test6@berkeley.edu', 'password3'), "")

        except ValueError as e:
            return (False, str(e))


    # test 7
    @classmethod
    def test007_loginerror_if_wrong_password(self):
        try:
            # create new account
            payload = {'email':'test7@berkeley.edu',
                       'username':'test7',
                       'password':'password7',
                       'password_confirmation':'password7'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            # try to login with wrong password - should fail
            payload = {'email':'test7@berkeley.edu',
                       'password':'weirdpassword'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            return (delete_account(idn, 'test7@berkeley.edu', 'password7'), "")
        
        except ValueError as e:
            return (False, str(e))


    # test 8
    @classmethod
    def test008_change_password(self):
        try:
            # create new account
            payload = {'email':'test8@berkeley.edu',
                       'username':'test8',
                       'password':'password8',
                       'password_confirmation':'password8'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']

            token = verify_and_login(idn, 'test8@berkeley.edu', 'password8')

            # change password

            headers = {'Authorization':token}
            payload = {'old':'password8',
                       'new':'newpass8',
                       'new_confirmation':'newpass8'}
            r = requests.post(SERVER + '/api/trainers/update', headers=headers, data=payload, timeout=20)
            if r.status_code != 200:
                raise ValueError("failed to change pass "+ str(r.json()['errors']) + str(r.status_code))


            # change password again

            headers = {'Authorization':token}
            payload = {'old':'newpass8',
                       'new':'newpass82',
                       'new_confirmation':'newpass82'}
            r = requests.post(SERVER + '/api/trainers/update', headers=headers, data=payload, timeout=20)
            if r.status_code != 200:
                raise ValueError("failed to change pass "+ str(r.json()['errors']) + str(r.status_code))


            # log out
            r = requests.delete(SERVER + '/api/sessions/' + str(token))

            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))
            


            # tried to login with old pass - should fail
            payload = {'email':'test8@berkeley.edu',
                       'password':'password8'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))


            # login with new pass - should pass

            payload = {'email':'test8@berkeley.edu',
                       'password':'newpass82'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to login with new pass " + str(r.json()['errors']) + str(r.status_code))
    
            
            
            return (delete_account(idn, 'test8@berkeley.edu', 'newpass82'), "")
        
        except ValueError as e:
            return (False, str(e))


    # test 9
    @classmethod
    def test009_reset_password(self):
        try:
            email = random_email()
            
            
            # create new account
            payload = {'email':email,
                       'username':'test9',
                       'password':'password9',
                       'password_confirmation':'password9'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            token = verify_and_login(idn, email, 'password9')


            # reset password
            payload = {'email':email}
            r = requests.post(SERVER + '/api/trainers/reset', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to reset password " + str(r.json()['errors']) + str(r.status_code))

            
            # tried to login with old pass - should fail
            payload = {'email':email,
                       'password':'password9'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))

            """
            # login with new pass - should succeed
            payload = {'email':'a6942847@hi.edu',
                       'password':'CPMRYSGP'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("login with old pass " + str(r.json()['errors']) + str(r.status_code))
            
            """

            return (True, "")
        
        except ValueError as e:
            return (False, str(e))


    # test 10
    @classmethod
    def test010_error_when_wrong_token(self):
        try:

            # try to verify with wrong token - should fail
            headers = {'Authorization':'asdfjwoeirfjwoefiejf'}
            r = requests.post(SERVER + '/api/trainers/confirm', headers=headers, timeout=20)
            
            if r.status_code == 200:
                raise ValueError("verification passed " + str(r.status_code))
            return (True, "")
        
        except ValueError as e:
            return (False, str(e))


    # test 11
    @classmethod
    def test011_error_when_reset_unregistered_email(self):
        try:
            payload = {'email':'test11@hi.edu'}
            r = requests.post(SERVER + '/api/trainers/reset', json=payload, timeout=20)


            if r.status_code == 200:
                raise ValueError("reset unregistered email? " + str(r.status_code))
            return (True, "")
        
        except ValueError as e:
            return (False, str(e))
            

    # test 12
    @classmethod
    def test012_error_when_logout_with_wrong_token(self):
        try:
            # create new account
            email = 'test12@hi.edu'
            
            payload = {'email':email,
                       'username':'test12',
                       'password':'password12',
                       'password_confirmation':'password12'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']
            token = verify_and_login(idn, email, 'password12')

            
            # try to logout with wrong token
            r = requests.delete(SERVER + '/api/sessions/' + 'hhhhhqqqqqeeeeeooooo')

            if r.status_code == 204:
                raise ValueError("logged out? " + str(r.status_code))
            
            return (delete_account(idn, email, 'password12'), "")
        
        except ValueError as e:
            return (False, str(e))


    # test 13
    @classmethod
    def test013_student_create_show(self):
        try:
            email = str(random.randint(0,9999999)) + '@hi.edu'
            
            # post
            payload = {'email':email,
                       'username':'test13',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed POST request " + str(r.status_code))

            idn = r.json()['id']

            # get
            r = requests.get(SERVER + '/api/students/' + str(idn), timeout=20)
            if r.status_code != 200:
                raise ValueError("failed GET request " + str(r.status_code))

            return (True, "")

        except ValueError as e:
            return (False, str(e))
        


    # test 14
    @classmethod
    def test014_login_logout_student(self):
        try:
            email = str(random.randint(0,9999999)) + '@hi.edu'
            # create new account
            payload = {'email':email,
                       'username':'test14',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account " + str(r.status_code))

            idn = r.json()['id']

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
                       'password':'password3'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.status_code))

            token = r.json()['auth_token']
            token = token.encode()

            # log out
            r = requests.delete(SERVER + '/api/sessions/' + str(token))

            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))


            # try to delete account with old token - should fail

            headers = {'Authorization':token}
            r = requests.delete(SERVER + '/api/students', headers=headers)

            if r.status_code == 204:
                raise ValueError("delete account-should fail " + str(r.status_code))

            
            return (True, "")


        except ValueError as e:
            return (False, str(e))
        
    



    # test 15
    @classmethod
    def test015_create_verify_login_delete_account_student(self):
        try:

            # create new account
            payload = {'email':'test15@berkeley.edu',
                       'username':'test15',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']

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
            payload = {'email':'test15@berkeley.edu',
                       'password':'password3'}
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

            return (True, "")


        except ValueError as e:
            return (False, str(e))
        


    # test 16
    @classmethod
    def test016_error_if_email_exist_student(self):
        try:
            # create new account
            payload = {'email':'test16@berkeley.edu',
                       'username':'test16',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']
            

            # create new account with same email address - should be fail
            payload = {'email':'test16@berkeley.edu',
                       'username':'test16-2',
                       'password':'password4',
                       'password_confirmation':'password4'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account_student(idn, 'test16@berkeley.edu', 'password1'), "")

        except ValueError as e:
            return (False, str(e))


    # test 17
    @classmethod
    def test017_error_if_email_exist_student_and_trainer(self):
        try:
            # create new account
            payload = {'email':'test17@berkeley.edu',
                       'username':'test17',
                       'password':'password1',
                       'password_confirmation':'password1'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']
            

            # create new account with same email address - should be fail
            payload = {'email':'test17@berkeley.edu',
                       'username':'test17-2',
                       'password':'password4',
                       'password_confirmation':'password4'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account_student(idn, 'test17@berkeley.edu', 'password1'), "")

        except ValueError as e:
            return (False, str(e))



    # test 18
    @classmethod
    def test018_error_if_password_doesnt_match_student(self):
        try:
            # create new account
            payload = {'email':'test18@berkeley.edu',
                       'username':'test18',
                       'password':'password1',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code == 201:
                raise ValueError("password does not match but still created " + str(r.status_code))
            return (True, "")

        except ValueError as e:
            return (False, str(e))



    # test 19
    @classmethod
    def test019_loginerror_if_unverified_student(self):
        try:
            # create new account
            payload = {'email':'test19@berkeley.edu',
                       'username':'test19',
                       'password':'password3',
                       'password_confirmation':'password3'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            # try to login before verification - should fail
            payload = {'email':'test19@berkeley.edu',
                       'password':'password3'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            return (delete_account_student(idn, 'test19@berkeley.edu', 'password3'), "")

        except ValueError as e:
            return (False, str(e))




    # test 20
    @classmethod
    def test020_loginerror_if_wrong_password_student(self):
        try:
            # create new account
            payload = {'email':'test20@berkeley.edu',
                       'username':'test20',
                       'password':'password7',
                       'password_confirmation':'password7'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            # try to login with wrong password - should fail
            payload = {'email':'test20@berkeley.edu',
                       'password':'weirdpassword'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            return (delete_account_student(idn, 'test20@berkeley.edu', 'password7'), "")
        
        except ValueError as e:
            return (False, str(e))



    # test 21
    @classmethod
    def test021_change_password(self):
        try:
            # create new account
            payload = {'email':'test21@berkeley.edu',
                       'username':'test21',
                       'password':'password8',
                       'password_confirmation':'password8'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']

            token = verify_and_login_student(idn, 'test21@berkeley.edu', 'password8')

            # change password

            headers = {'Authorization':token}
            payload = {'old':'password8',
                       'new':'newpass8',
                       'new_confirmation':'newpass8'}
            r = requests.post(SERVER + '/api/students/update', headers=headers, data=payload, timeout=20)
            if r.status_code != 200:
                raise ValueError("failed to change pass "+ str(r.json()['errors']) + str(r.status_code))


            # change password again

            headers = {'Authorization':token}
            payload = {'old':'newpass8',
                       'new':'newpass82',
                       'new_confirmation':'newpass82'}
            r = requests.post(SERVER + '/api/students/update', headers=headers, data=payload, timeout=20)
            if r.status_code != 200:
                raise ValueError("failed to change pass "+ str(r.json()['errors']) + str(r.status_code))


            # log out
            r = requests.delete(SERVER + '/api/sessions/' + str(token))

            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))
            


            # tried to login with old pass - should fail
            payload = {'email':'test21@berkeley.edu',
                       'password':'password8'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))


            # login with new pass - should pass

            payload = {'email':'test21@berkeley.edu',
                       'password':'newpass82'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to login with new pass " + str(r.json()['errors']) + str(r.status_code))
    
            
            
            return (delete_account_student(idn, 'test21@berkeley.edu', 'newpass82'), "")
        
        except ValueError as e:
            return (False, str(e))




    # test 22
    @classmethod
    def test022_reset_password_student(self):
        try:
            email = random_email()
            
            
            # create new account
            payload = {'email':email,
                       'username':'test22',
                       'password':'password9',
                       'password_confirmation':'password9'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']


            token = verify_and_login_student(idn, email, 'password9')


            # reset password
            payload = {'email':email}
            r = requests.post(SERVER + '/api/students/reset', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("failed to reset password " + str(r.json()['errors']) + str(r.status_code))

            
            # tried to login with old pass - should fail
            payload = {'email':email,
                       'password':'password9'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))

            """
            # login with new pass - should succeed
            payload = {'email':'a6942847@hi.edu',
                       'password':'CPMRYSGP'}
            r = requests.post(SERVER + '/api/sessions', json=payload, timeout=20)

            if r.status_code != 200:
                raise ValueError("login with old pass " + str(r.json()['errors']) + str(r.status_code))
            
            """

            return (True, "")
        
        except ValueError as e:
            return (False, str(e))
            

    # test 23
    @classmethod
    def test023_error_when_logout_with_wrong_token_student(self):
        try:
            # create new account
            email = 'test23@hi.edu'
            
            payload = {'email':email,
                       'username':'test23',
                       'password':'password12',
                       'password_confirmation':'password12'}
            r = requests.post(SERVER + '/api/students', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))

            idn = r.json()['id']
            token = verify_and_login_student(idn, email, 'password12')

            
            # try to logout with wrong token
            r = requests.delete(SERVER + '/api/sessions/' + 'hhhhhqqqqqeeeeeooooo')

            if r.status_code == 204:
                raise ValueError("logged out? " + str(r.status_code))
            
            return (delete_account_student(idn, email, 'password12'), "")
        
        except ValueError as e:
            return (False, str(e))



    # test 24
    @classmethod
    def test024_trainer_upload_csv(self):
        try:
            email = random_email()
            
            # post
            payload = {'email':email,
                       'username':'test24',
                       'password':'password24',
                       'password_confirmation':'password24'}
            r = requests.post(SERVER + '/api/trainers', json=payload, timeout=20)
            if r.status_code != 201:
                raise ValueError("failed POST request " + str(r.status_code))

            idn = r.json()['id']


            # create new session (logging in)
            payload = {'email':email,
                       'password':'password24'}
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
        
                         
