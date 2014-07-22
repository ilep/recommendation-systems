# -*- coding: utf-8 -*-
"""
Created on Mon Jul 21 16:38:44 2014

@author: ivan lepoutre
"""

import numpy as np

#------------------------------------------------------------------------------------------------------
# I/ User Based Collaborative Filtering 
#------------------------------------------------------------------------------------------------------

# Rating matrix R with 6 users ( + active user) and 8 items
R = np.array([

    [0, 1, 1, 1, 1, 0, 0, 0], # interests of user 1 for the p=8 items
    [1, 0, 0, 0, 1, 1, 0, 0], # interests of user 2 for the p=8 items
    [0, 0, 0, 1, 0, 1, 0, 1], # interests of user 3 for the p=8 items
    [0, 0, 0, 1, 1, 1, 0, 1], # interests of user 4 for the p=8 items
    [1, 1, 0, 0, 0, 0, 0, 1], # interests of user 5 for the p=8 items
    [0, 1, 0, 0, 1, 1, 0, 1], # interests of user 6 for the p=8 items
    # ---------------------------------------------------------------
    [0, 0, 1, 1, 0, 1, 0, 1]  # interests of active user A for the p=8 items
])

n, p = map(int, R.shape) # there are n = 7 users and p = 8 items

users = {} # list of users
users[1] = 0; r_1 = R[users[1],:] # user 1 profile vector
users[2] = 1; r_2 = R[users[2],:] # user 2 profile vector
users[3] = 2; r_3 = R[users[3],:] # user 3 profile vector
users[4] = 3; r_4 = R[users[4],:] # user 4 profile vector
users[5] = 4; r_5 = R[users[5],:] # user 5 profile vector
users[6] = 5; r_6 = R[users[6],:] # user 6 profile vector
# ---------------------------------------------------
a = 7 # active user 
users[a] = 6; r_a = R[users[a],:] # user a profile vector


# return the jacard similarity between two users defined by their user profile vectors
def jacardSimilarity(user_x, user_y, R, users):
    n, p = map(int, R.shape)    
    r_x = R[users[user_x],:]   
    r_y = R[users[user_y],:]   
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

# plot the matrix of similarities between users and return this matrix
def plotSimilarities(R, users):
    sim = np.empty([n,n], dtype=np.dtype(np.float))
    for user_x, index_x in users.iteritems():    
        for user_y, index_y in users.iteritems():  
            sim[index_x, index_y] = jacardSimilarity(user_x, user_y, R, users) 
    from pylab import pcolor, show, colorbar, xticks, yticks
    pcolor(sim)
    colorbar()
    yticks(np.arange(0.5,7.5),range(1,n+1))
    xticks(np.arange(0.5,7.5),range(1,n+1))
    show()
    return sim
 
# return the k closest neighbors from user    
def neighborhood(user, k, R, users):
    sim = plotSimilarities(R,users)
    neighbors = np.argsort(sim[user-1, :])[-(k+1):-1] + 1
    return neighbors
    
    
    
    
    
    