#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Data Visualizations for RABV Genomes Downloaded from GenBank
#Andrew Holtz
#28 October 2020


import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns

if '__main__' == __name__:
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--input_data', required=True, type=str)
    parser.add_argument('--output_length', required=True, type=str)
    parser.add_argument('--output_country', required=True, type=str)
    parser.add_argument('--output_host', required=True, type=str)
    parser.add_argument('--output_year', required=True, type=str)
    params = parser.parse_args()

    #meta = pd.read_table('./ncbi_cleaned.tab', index_col = 0)
    meta = pd.read_table(params.input_data, index_col=1)

    #Plot for Genome Length
    sns.displot(meta.Length, color = 'g', palette = 'muted', binwidth = 50)
    plt.xlabel("Genome Length")
    plt.title("Genome Length of RABV in Dataset")
    plt.savefig(params.output_length)
    #print(meta['Length'].describe())



    #Plot for Country Distribution

    plt.figure(figsize = (11,7))
    plt.xlabel("Country of Collection")
    plt.title("Top 10 Countries for RABV Collection")
    sns.countplot(data = meta, x = 'Country.1', palette = 'muted', order=pd.value_counts(meta['Country.1']).iloc[:10].index)
    plt.savefig(params.output_country)
    #print(meta['Country.1'].describe())


    #Plot for Host Species Distribution

    plt.figure(figsize = (11,7))
    plt.xlabel("Host Isolation Species")
    plt.title("Top 5 Host Isolation Species for RABV Collection")
    sns.countplot(data = meta, x = 'Host', palette = 'Set2', order=pd.value_counts(meta['Host']).iloc[:5].index)
    plt.savefig(params.output_host)
    #print(meta['Host'].describe())


    #Plot of Year Distribution

    sns.displot(meta.Collection_Date, palette = 'muted')
    plt.xlabel("Year of Collection")
    plt.title("Year of RABV Virus Colletion")
    plt.savefig(params.output_year)
    #print(meta['Collection_Date'].describe())


