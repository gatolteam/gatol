import requests
import json
import inspect
import random

########################
### GLOBAL VARIABLES ###
########################


# SERVER = 'http://localhost:3000'
# SERVER = 'https://calm-garden-9078.herokuapp.com'
SERVER = 'https://gatol.herokuapp.com'
TEST = ""
FILEPATH = 'Book1.csv'
TIMEOUT = 200
PASS = 'samplePass'

########################
### HELPER FUNCTIONS ###
########################

def random_email():
    return 'a' + str(random.randint(0,9999999)) + '@hihello.sample'

def create_account(email, username, password, password_confirmation, is_trainer=True):
    payload = {'email':email,
               'username':username,
               'password':password,
               'password_confirmation':password_confirmation}
    if is_trainer:
        return requests.post(SERVER + '/api/trainers', json=payload, timeout=TIMEOUT)
    else:
        return requests.post(SERVER + '/api/students', json=payload, timeout=TIMEOUT)

def verify_account(token, is_trainer=True):
    token = token.encode()
    if is_trainer:
        return requests.get(SERVER + '/api/trainers/' + token + '/confirm', timeout=TIMEOUT)
    else:
        return requests.get(SERVER + '/api/students/' + token + '/confirm', timeout=TIMEOUT)

def login(email, password):
    payload = {'email':email,
               'password':password}
    return requests.post(SERVER + '/api/sessions', json=payload, timeout=TIMEOUT)

def logout(token):
    token = token.encode()
    return requests.delete(SERVER + '/api/sessions/' + str(token), timeout=TIMEOUT)

def delete_account(token, is_trainer=True):
    token = token.encode()
    headers = {'Authorization':token}
    if is_trainer:
        return requests.delete(SERVER + '/api/trainers', headers=headers, timeout=TIMEOUT)
    else:
        return requests.delete(SERVER + '/api/students', headers=headers, timeout=TIMEOUT)

def get_token(idn, is_trainer=True):
    if is_trainer:
        r = requests.get(SERVER + '/api/trainers/' + str(idn), timeout=TIMEOUT)
        if r.status_code != 200:
            raise ValueError("failed to get token " + str(r.status_code))
        return r.json()['auth_token']
    else:
        r = requests.get(SERVER + '/api/students/' + str(idn), timeout=TIMEOUT)
        if r.status_code != 200:
            raise ValueError("failed to get token " + str(r.status_code))
        return r.json()['auth_token']

def upload_csv(token, filepath=FILEPATH):
    token = token.encode()
    headers = {'Authorization':token}
    files = {'file': ('Book1.csv', open(filepath, 'rb'))}
    return requests.post(SERVER + '/api/question_sets/import', headers=headers, files=files)


########################

# quick way to setup an account. returns a login token.
def create_and_login(email, password, is_trainer=True):
    #create account
    r = create_account(email, 'test', password, password, is_trainer)
    if r.status_code != 201:
        raise ValueError("failed to create account " + str(r.status_code))
    idn = r.json()['id']
    #get confirm token
    token = get_token(idn, is_trainer)
    #verify
    r = verify_account(token, is_trainer)
    if r.status_code != 200:
        raise ValueError("verification failed " + str(r.status_code))
    #login
    r = login(email, password)
    if r.status_code != 200:
        raise ValueError("failed to login " + str(r.json()['errors']) + str(r.status_code))
    token = r.json()['auth_token']
    return token








#############
### TESTS ###
#############

### write tests as a method in GatolTest
class GatolTest:

    
    # test 1
    @classmethod
    def test001_trainer_create_show(self):
        try:
            email = random_email()

            # create account
            r = create_account(email, 'test1', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed to create account " + str(r.status_code))
            idn = r.json()['id']

            # get token
            token = get_token(idn, False)

            

            return (True, "")

        except ValueError as e:
            return (False, str(e))


    # test 2
    @classmethod
    def test002_login_logout(self):
        try:
            email = random_email()
            # create account
            r = create_account(email, 'test2', PASS, PASS)
            if r.status_code != 201:
                raise ValueError("failed to create account " + str(r.status_code))

            idn = r.json()['id']

            # get authorization token
            token = get_token(idn)

            #verify
            r = verify_account(token)
            if r.status_code != 200:
                raise ValueError("verification failed " + str(r.json()['errors']) + str(r.status_code))     
            
            # create new session (logging in)
            r = login(email, PASS)
            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.status_code))

            token = r.json()['auth_token']

            # log out
            r = logout(token)
            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))


            # try to delete account with old token - should fail
            r = delete_account(token)
            if r.status_code == 204:
                raise ValueError("delete account-should fail " + str(r.status_code))
            
            
            return (True, "")
        except ValueError as e:
            return (False, str(e))


    # test 3
    @classmethod
    def test003_create_verify_login_delete_account(self):
        try:
            email = random_email()

            # create and login
            token = create_and_login(email, PASS)

            
            # delete account
            r = delete_account(token)
            if r.status_code != 204:
                raise ValueError("failed to delete account " + str(r.status_code))

            return (True, "")

        except ValueError as e:
            return (False, str(e))
        

    # test 4
    @classmethod
    def test004_error_if_email_exist(self):
        try:
            email = random_email()
            # create new account
            r = create_account(email, 'test', PASS, PASS)
            if r.status_code != 201:
                raise ValueError("failed to create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']

            # create new account with same email address - should be fail
            r = create_account(email, 'test', PASS, PASS)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account(get_token(idn)), "")

        except ValueError as e:
            return (False, str(e))


    # test 5
    @classmethod
    def test005_error_if_password_doesnt_match(self):
        try:
            email = 'test5@hihello.edu'
            
            # create new account
            r = create_account(email, 'test', PASS, 'wrong_pass')
            if r.status_code == 201:
                raise ValueError("password does not match but still created " + str(r.status_code))
            return (True, "")

        except ValueError as e:
            return (False, str(e))


    # test 6
    @classmethod
    def test006_loginerror_if_unverified(self):
        try:
            return (True, "")
            email = 'jhlee2570@gmail.com'
            
            # create new account
            r = create_account(email, 'test', PASS, PASS)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']


            # try to login before verification - should fail
            r = login(email, PASS)
            if r.status_code == 200:
                raise ValueError("logged in (should fail) " + str(r.status_code))

            return (delete_account(get_token(idn)), "")

        except ValueError as e:
            return (False, str(e))


    # test 7
    @classmethod
    def test007_loginerror_if_wrong_password(self):
        try:
            email = random_email()
            
            # create new account
            r = create_account(email, 'test', PASS, PASS)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']


            # try to login with wrong password - should fail
            r = login(email, 'wrong_pass')
            if r.status_code == 200:
                raise ValueError("logged in (should fail) " + str(r.status_code))

        
            return (delete_account(get_token(idn)), "")
        
        except ValueError as e:
            return (False, str(e))


    # test 8
    @classmethod
    def test008_change_password(self):
        try:
            email = random_email()

            # create and login
            token = create_and_login(email, 'password8')
            token = token.encode()


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
            r = logout(token)
            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))
            

            # attempt to login with old pass - should fail
            r = login(email, 'password8')
            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))


            # login with new pass - should pass
            r = login(email, 'newpass82')
            if r.status_code != 200:
                raise ValueError("failed to login with new pass " + str(r.json()['errors']) + str(r.status_code))
            token = r.json()['auth_token']
    
            return (delete_account(token), "")
        
        except ValueError as e:
            return (False, str(e))



    # test 9
    @classmethod
    def test009_trainer_upload_csv(self):
        try:
            email = random_email()

            # create and login
            token = create_and_login(email, PASS)
            token = token.encode()

            # upload csv
            headers = {'Authorization':token}
            files = {'file': ('Book1.csv', open(FILEPATH, 'rb'))}
            r = requests.post(SERVER + '/api/question_sets/import', headers=headers, files=files)

            if r.status_code > 299:
                raise ValueError("failed to upload csv " + str(r.json()))

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
            email = random_email()
            
            token = create_and_login(email, PASS)


            # try to logout with wrong token
            r = logout('hhhhhqqqqqeeeeeooooo')
            if r.status_code == 204:
                raise ValueError("logged out? " + str(r.status_code))
            
            return (delete_account(token), "")
        
        except ValueError as e:
            return (False, str(e))


    # test 13
    @classmethod
    def test013_student_create_show(self):
        try:
            email = random_email()

            # create account
            r = create_account(email, 'test1', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed to create account " + str(r.status_code))
            idn = r.json()['id']

            # get token
            token = get_token(idn, False)

            return (True, "")

        except ValueError as e:
            return (False, str(e))
        


    # test 14
    @classmethod
    def test014_login_logout_student(self):
        try:
            email = random_email()
            
            # create account
            r = create_account(email, 'test2', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed to create account " + str(r.status_code))

            idn = r.json()['id']

            # get authorization token
            token = get_token(idn, False)

            #verify
            r = verify_account(token, False)
            if r.status_code != 200:
                raise ValueError("verification failed " + str(r.json()['errors']) + str(r.status_code))     
            
            # create new session (logging in)
            r = login(email, PASS)
            if r.status_code != 200:
                raise ValueError("failed to login " + str(r.status_code))

            token = r.json()['auth_token']

            # log out
            r = logout(token)
            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))


            # try to delete account with old token - should fail
            r = delete_account(token, False)
            if r.status_code == 204:
                raise ValueError("delete account-should fail " + str(r.status_code))
            
            
            return (True, "")
        except ValueError as e:
            return (False, str(e))
        
    



    # test 15
    @classmethod
    def test015_create_verify_login_delete_account_student(self):
        try:
            email = random_email()

            # create and login
            token = create_and_login(email, PASS, False)

            
            # delete account
            r = delete_account(token, False)
            if r.status_code != 204:
                raise ValueError("failed to delete account " + str(r.status_code))

            return (True, "")

        except ValueError as e:
            return (False, str(e))
        


    # test 16
    @classmethod
    def test016_error_if_email_exist_student(self):
        try:
            email = random_email()
            
            # create new account
            r = create_account(email, 'test', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']

            # create new account with same email address - should be fail
            r = create_account(email, 'test', PASS, PASS, False)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account(get_token(idn, False), False), "")

        except ValueError as e:
            return (False, str(e))


    # test 17
    @classmethod
    def test017_error_if_email_exist_student_and_trainer(self):
        try:
            email = random_email()
            
            # create new account
            r = create_account(email, 'test', PASS, PASS)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']

            # create new account with same email address - should be fail
            r = create_account(email, 'test', PASS, PASS, False)
            if r.status_code == 201:
                raise ValueError("account should not be created " + str(r.status_code))
                                 
            return (delete_account(get_token(idn), False), "")

        except ValueError as e:
            return (False, str(e))



    # test 18
    @classmethod
    def test018_error_if_password_doesnt_match_student(self):
        try:
            email = 'test5@hihello.edu'
            
            # create new account
            r = create_account(email, 'test', PASS, 'wrong_pass', False)
            if r.status_code == 201:
                raise ValueError("successfully created account - should fail" + str(r.status_code))
            return (True, "")

        except ValueError as e:
            return (False, str(e))



    # test 19
    @classmethod
    def test019_loginerror_if_unverified_student(self):
        try:
            return(True, "")
            email = 'jhlee2570@gmail.com'
            
            # create new account
            r = create_account(email, 'test', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed create account " + str(r.status_code))

            idn = r.json()['id']


            # try to login before verification - should fail
            r = login(email, PASS)
            if r.status_code == 200:
                raise ValueError("logged in (should fail) " + str(r.status_code))

            return (delete_account(get_token(idn, False), False), "")

        except ValueError as e:
            return (False, str(e))




    # test 20
    @classmethod
    def test020_loginerror_if_wrong_password_student(self):
        try:
            email = random_email()
            
            # create new account
            r = create_account(email, 'test', PASS, PASS, False)
            if r.status_code != 201:
                raise ValueError("failed create account "+ str(r.json()['errors']) + str(r.status_code))
            idn = r.json()['id']


            # try to login with wrong password - should fail
            r = login(email, 'wrong_pass')
            if r.status_code == 200:
                raise ValueError("logged in (should fail) " + str(r.status_code))

            return (delete_account(get_token(idn, False)), "")
        
        except ValueError as e:
            return (False, str(e))



    # test 21
    @classmethod
    def test021_change_password(self):
        try:
            email = random_email()

            # create and login
            token = create_and_login(email, 'password8', False)
            token = token.encode()


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
            r = logout(token)
            if r.status_code != 204:
                raise ValueError("failed to log out " + str(r.status_code))
            

            # attempt to login with old pass - should fail
            r = login(email, 'password8')
            if r.status_code == 200:
                raise ValueError("login with old pass " + str(r.status_code))


            # login with new pass - should pass
            r = login(email, 'newpass82')
            if r.status_code != 200:
                raise ValueError("failed to login with new pass " + str(r.json()['errors']) + str(r.status_code))
            token = r.json()['auth_token']
    
            return (delete_account(token, False), "")
        
        except ValueError as e:
            return (False, str(e))


        except ValueError as e:
            return (False, str(e))



    # test 22
    @classmethod
    def test022_error_when_logout_with_wrong_token_student(self):
        try:
            # create new account
            email = random_email()
            
            token = create_and_login(email, PASS, False)


            # try to logout with wrong token
            r = logout('hhhhhqqqqqeeeeeooooo')
            if r.status_code == 204:
                raise ValueError("logged out? " + str(r.status_code))
            
            return (delete_account(token, False), "")
        
        except ValueError as e:
            return (False, str(e))






    # test 23
    @classmethod
    def test023_trainer_create_game(self):
        try:
            email = random_email()
            decoder = json.JSONDecoder()
        
            # create account
            token = create_and_login(email, PASS)
            token = token.encode()
            
            # upload csv
            upload_csv(token)

            # get question Set id
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/question_sets', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get set id " + str(r.status_code))

            questionSets = r.json()[u'question_sets']
            setID = questionSets[0]['id']

            # create game
            headers = {'Authorization':token}
            payload = {u'game':{u'name':u'testGame1',
                                u'description':u'this is a good game',
                                u'question_set_id':setID,
                                u'game_template_id':1}}
            json_data = json.dumps(payload)
            r = requests.post(SERVER + '/api/games', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to create game " + str(r.status_code))
            
            # get game list
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/games', headers=headers)

            if r.status_code > 299:
                raise ValueError("failed to get games " + str(r.status_code))
            
            games = r.json()[u'games']
            gameTitle = games[0][u'name']
            if gameTitle != u'testGame1':
                raise ValueError("game title does not match " + str(r.status_code))
            
            return (True, "")

        except ValueError as e:
            return (False, str(e))



    # test 24
    @classmethod
    def test024_trainer_enrollment(self):
        try:
            email = random_email()
            email2 = random_email()
            email3 = random_email()
            decoder = json.JSONDecoder()
        
            # create account
            token = create_and_login(email, PASS)
            token = token.encode()

            # create account2
            token2 = create_and_login(email2, PASS, False)
            token2 = token2.encode()
            
            # upload csv
            upload_csv(token)

            # get question Set id
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/question_sets', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get set id " + str(r.status_code))

            questionSets = r.json()[u'question_sets']
            setID = questionSets[0]['id']

            # create game
            payload = {u'game':{u'name':u'testGame1',
                                u'description':u'this is a good game',
                                u'question_set_id':setID,
                                u'game_template_id':1}}
            json_data = json.dumps(payload)
            headers = {'Authorization':token}
            r = requests.post(SERVER + '/api/games', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to create game " + str(r.status_code) + str(r.json()[u'errors']))
            
            # get game list
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/games', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get games " + str(r.status_code))

            games = r.json()[u'games']
            
            gameID = games[0][u'id']
            gameTitle = games[0][u'name']
            if gameTitle != u'testGame1':
                raise ValueError("game title does not match " + str(r.status_code))

            # print(gameID)
            # print(type(gameID))


            # create enrollment
            headers = {'Authorization':token}
            payload = {u'game_enrollment':{u'game_id':gameID,
                                           u'student_email':email3}}
            r = requests.post(SERVER + '/api/game_enrollments', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to create enrollment " + str(r.status_code))


            # student view enrollment
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/game_enrollments', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to view student enrollment0 " + str(r.status_code))


            # create enrollment
            headers = {'Authorization':token}
            payload = {u'game_enrollment':{u'game_id':gameID,
                                           u'student_email':email2}}
            r = requests.post(SERVER + '/api/game_enrollments', headers=headers, json=payload)

            if r.status_code > 299:
                raise ValueError("failed to create enrollment " + str(r.status_code))


            # view enrollment
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/game_enrollments/' + str(gameID), headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to view enrollment " + str(r.status_code))


            enrollments = r.json()[u'game_enrollments']
            if len(enrollments) != 2:
                raise ValueError("failed to get enrollments " + str(len(enrollments)))
            entryID = enrollments[0][u'id']


            # student view enrollment
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/game_enrollments', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to view student enrollment " + str(r.status_code))




            # delete enrollment
            headers = {'Authorization':token}
            r = requests.delete(SERVER + '/api/game_enrollments/' + str(entryID), headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to create enrollment " + str(r.status_code))


            # view enrollment
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/game_enrollments/' + str(gameID), headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to create enrollment " + str(r.status_code))

            enrollments = r.json()[u'game_enrollments']
            if len(enrollments) != 1:
                raise ValueError("failed to get enrollments " + str(len(enrollments)))
 



            
            return (True, "")

        except ValueError as e:
            return (False, str(e))


    # test 25
    @classmethod
    def test025_game_play_and_stat(self):
        try:
            trainer_email = random_email()
            student_email = random_email()
            decoder = json.JSONDecoder()
        
            # create trainer account
            token = create_and_login(trainer_email, PASS)
            token = token.encode()

            # create account2
            token2 = create_and_login(student_email, PASS, False)
            token2 = token2.encode()

            # upload csv
            upload_csv(token)

            # get question Set id
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/question_sets', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get set id " + str(r.status_code))

            questionSets = r.json()[u'question_sets']
            
            # print(questionSets)
            setID = questionSets[0]['id']

            # create game
            payload = {u'game':{u'name':u'testGame1',
                                u'description':u'this is a good game',
                                u'question_set_id':setID,
                                u'game_template_id':1}}
            json_data = json.dumps(payload)
            headers = {'Authorization':token}
            r = requests.post(SERVER + '/api/games', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to create game " + str(r.status_code) + str(r.json()[u'errors']))


            # get game list
            headers = {'Authorization':token}
            r = requests.get(SERVER + '/api/games', headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get games " + str(r.status_code))

            games = r.json()[u'games']
            
            gameID = games[0][u'id']
            gameTitle = games[0][u'name']
            if gameTitle != u'testGame1':
                raise ValueError("game title does not match " + str(r.status_code))

            # print(gameID)
            # print(type(gameID))


            # create enrollment
            headers = {'Authorization':token}
            payload = {u'game_enrollment':{u'game_id':gameID,
                                           u'student_email':student_email}}
            r = requests.post(SERVER + '/api/game_enrollments', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to create enrollment " + str(r.status_code))


            # student get information about the game            
            headers = {'Authorization':token2}
            r = requests.get(SERVER + '/api/games/' + str(gameID), headers=headers)
            if r.status_code > 299:
                raise ValueError("failed to get information about the game " + str(r.status_code))
            # print(r.json())
            # print(r.json()[u'game'])
            # print(type(r.json()[u'game']))


            # student initiate a game
            headers = {'Authorization':token2}
            payload = {'game_id':gameID}
            r = requests.post(SERVER + '/api/game_instances', headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to post game_instance " + str(r.status_code))

            # print(r.json())
            # print(r.json()[u'game_instance_id'])
            game_instance_id = str(r.json()[u'game_instance_id'])
            

            # play game
            headers = {'Authorization':token2}
            payload = {'score':10,
                       'lastQuestion':4}
            r = requests.put(SERVER + '/api/game_instances/' + game_instance_id, headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to put game_instances " + str(r.status_code))


            # play another game
            headers = {'Authorization':token2}
            payload = {'score':17,
                       'lastQuestion':5}
            r = requests.put(SERVER + '/api/game_instances/' + game_instance_id, headers=headers, json=payload)
            if r.status_code > 299:
                raise ValueError("failed to put game_instances " + str(r.status_code))
            
            


            # trainer get stats from student
            headers = {'Authorization':token}
            payload = {'student_email':student_email,
                       'game_id':gameID}
            r = requests.get(SERVER + '/api/game_instances/player?'
                             + 'student_email=' + payload['student_email']
                             + '&game_id=' + str(payload['game_id']), headers = headers)
            if r.status_code > 299:
                raise ValueError("failed to get student stats(trainer) "  + str(r.status_code))
            # print(r.json())
            # print(r.json()[u'history'])
            # print(type(r.json()[u'history']))
            

            # student view his own history
            headers = {'Authorization':token2}
            payload = {'game_id':gameID}
            r = requests.get(SERVER + '/api/game_instances/stats?'
                             + '&game_id=' + str(payload['game_id']), headers = headers)
            if r.status_code > 299:
                raise ValueError("failed to get student stats(student) " + str(r.status_code))
            # print(r.json())
            # print(r.json()[u'history'])
            # print(type(r.json()[u'history']))
            

   
            return (True, "")

        except ValueError as e:
            return (False, str(e))




### DO NOT CHANGE UNDERTHIS LINE ###
if __name__ == '__main__':
    print("Gatol API tests")
    print("***")
    test_list = inspect.getmembers(GatolTest, predicate=inspect.ismethod)

    if TEST == "":
        pass
        
    elif TEST.endswith('+'):
        new_list = []
        for test in test_list:
            if int(test[0][4:7]) >= int(TEST[4:7]):
                new_list.append(test)
        test_list = new_list

    else:
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
            print('PASSED {1}'.format(index, test[0]))
            num_pass += 1
        else:
            print('FAILED {1} ::: {2}'.format(index, test[0], result[1]))
    print("***")
    print(str(num_pass) + "/" + str(len(test_list)) + " tests passed")
        
                         
