#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import zentables as zen


# In[2]:


url = (
    "https://raw.githubusercontent.com/thepolicylab"
    "/ZenTables/main/tests/fixtures/superstore.csv?raw=true"
)
super_store = pd.read_csv(url)


# In[5]:


df = super_store.pivot_table(
    index=["Segment", "Region"],
    columns=["Category"],
    values="Order ID",
    aggfunc="count",
    margins=True
)
df


# In[9]:


table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
import pandas as pd
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
df = pd.DataFrame(table, columns = ['a', 'b', 'c', 'd'], index=['row_1', 'row_2'])
print(df)
from tabulate import tabulate
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
print(tabulate(table))


# In[10]:


table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
print(tabulate(table, headers='firstrow', tablefmt='fancy_grid'))


# In[17]:


#More tabulate
from tabulate import tabulate


# In[18]:


nba_players = [['LeBron James',' Los Angeles Lakers'], ['Kevin Durant', 'Brooklyn Nets'], ['Stephen Curry', 'Golden State Warriors']]
print(tabulate(nba_players,headers =['Player','Team']))


# In[19]:


print(tabulate(nba_players,headers =['Player','Team'],tablefmt = 'fancy_grid'))


# In[20]:


print(tabulate(nba_players,headers =['Player','Team'],tablefmt = 'fancy_grid',stralign='center'))


# In[12]:


from prettytable import PrettyTable
table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
tab = PrettyTable(table[0])
tab.add_rows(table[1:])
tab.add_column('col 5', [-123, 43], align='r', valign='t')
print(tab)


# In[14]:


from prettytable import PrettyTable


# In[15]:


t = PrettyTable(['Name', 'Age'])
t.add_row(['Alice', 24])
t.add_row(['Bob', 19])
print(t)


# In[16]:


from texttable import Texttable
t = Texttable()
t.add_rows([['Name', 'Age'], ['Alice', 24], ['Bob', 19]])
print(t.draw())


# In[ ]:




