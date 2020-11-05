



if '__main__' == __name__:

    from Bio import SeqIO
    from Bio.Seq import Seq
    import os.path
    from pathlib import Path

    fasta = Path("/Volumes/@home/rabies/data/aln.ref.fa")

    for rec in SeqIO.parse(fasta, "fasta"):

        dashN = '-' in rec.seq[70:1422] # 71-1423 - N coding
        dashP = '-' in rec.seq[1513:2406]  # 1514-2407 - P coding
        dashM = '-' in rec.seq[2495:3103]  # 2496-3104 - M coding
        dashG = '-' in rec.seq[3317:4891]  # 3318-4892 - G coding
        dashL = '-' in rec.seq[5417:11845]  # 5418-11846 - L coding

        if dashN == True:
            print(str(rec.id) + " N coding")
            print(rec.seq[70:1422].find("-") + 70)

        if dashP == True:
            print(str(rec.id) + " P coding")
            print(rec.seq[1513:2406].find("-") + 1513)

        if dashM == True:
            print(str(rec.id) + " M coding")
            print(rec.seq[2495:3103].find("-") + 2495)

        if dashG == True:
            print(str(rec.id) + " G coding")
            print(rec.seq[3317:4891].find("-") + 3317)

        if dashL == True:
            print(str(rec.id) + " L coding")
            print(rec.seq[5417:11845].find("-") + 5417)





