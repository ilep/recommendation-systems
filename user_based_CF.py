# -*- coding: utf-8 -*-
"""
Created on Mon Jul 21 16:38:44 2014

@author: ivan lepoutre
"""

import numpy as np

# rating matrix
M = np.array([

    [0, 1, 1, 1, 1, 0, 0, 0], # interests of user 1 for the p=8 items
    [1, 0, 0, 0, 1, 1, 0, 0], # interests of user 2 for the p=8 items
    [0, 0, 0, 1, 0, 1, 0, 1], # interests of user 3 for the p=8 items
    [0, 0, 0, 1, 1, 1, 0, 1], # interests of user 4 for the p=8 items
    [1, 1, 0, 0, 0, 0, 0, 1], # interests of user 5 for the p=8 items
    [0, 1, 0, 0, 1, 1, 0, 1], # interests of user 6 for the p=8 items
    # ---------------------------------------------------------------
    [0, 0, 1, 1, 0, 1, 0, 1]  # interests of active user A for the p=8 items
])

n, p = map(int, M.shape) # there are n = 7 users and p = 8 items

user = {} # list of users


user[1] = 0; r_1 = M[user[1],:] # user 1 profile vector
user[2] = 1; r_2 = M[user[2],:] # user 2 profile vector
user[3] = 2; r_3 = M[user[3],:] # user 3 profile vector
user[4] = 3; r_4 = M[user[4],:] # user 4 profile vector
user[5] = 4; r_5 = M[user[5],:] # user 5 profile vector
user[6] = 5; r_6 = M[user[6],:] # user 6 profile vector
# ---------------------------------------------------
a = 7 # active user 
user[a] = 6; r_a = M[user[a],:] # user a profile vector



# return the jacard similarity between two users defined by their user profile vectors
def jacardSimilarity(user_x, user_y, M):
    n, p = map(int, M.shape)    
    r_x = M[user[user_x],:]   
    r_y = M[user[user_y],:]   
    card_intersection = np.sum(r_x*r_y)
    card_union = 0
    for j in range(p):
        if r_x[j] == 0 and r_y[j] == 0:
            prod =0
        else:
            prod=1
        card_union = card_union + prod
    sim = 1.0*card_intersection / card_union
    return sim


def plotSimilarities():
    sim = np.empty([n,n], dtype=np.dtype(np.float))
    for user_x, row_x in user.iteritems():    
        for user_y, row_y in user.iteritems():  
            sim[row_x, row_y] = jacardSimilarity(user_x, user_y, M) 
    from pylab import pcolor, show, colorbar, xticks, yticks
    pcolor(sim)
    colorbar()
    yticks(np.arange(0.5,7.5),range(1,n+1))
    xticks(np.arange(0.5,7.5),range(1,n+1))
    show()

# compute 
#def jacardSimilarities(M):
    



# return     
#def neighborhood(user):
    

    
    
    
    
    
    
    
    