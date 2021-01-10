# -*- coding: utf-8 -*-

#Inutile vu qu'on ne randomise plus des parties mais qu'on génère tout en bruteforce
#import random
#Inutile vu que JSON plus utilisé pour la sérialisation
#import json

#Intialisation de la grille à vide
grille_vide = ["", "", "", "", "", "", "", "", ""]

#Fonction qui permet d'importer une ligne donnée du fichier 
def import_grille(noligne):
    fic_grilles = './grilles.txt'
    ma_ligne = ""
    with open(fic_grilles, 'r') as file_object:
        for i, ligne in enumerate(file_object):
            if i == noligne:
                ma_ligne = ligne.rstrip("\n")
            elif i > noligne:
                break
    return(ma_ligne.split(","))

#Une fonction utilitaire, qui permet de visualiser n'importe quelle partie de morpion dans un tableau type
def print_tic_tac_toe(values):
    print("\n")
    print("\t     |     |")
    print("\t  {}  |  {}  |  {}".format(values[0], values[1], values[2]))
    print('\t_____|_____|_____')

    print("\t     |     |")
    print("\t  {}  |  {}  |  {}".format(values[3], values[4], values[5]))
    print('\t_____|_____|_____')

    print("\t     |     |")

    print("\t  {}  |  {}  |  {}".format(values[6], values[7], values[8]))
    print("\t     |     |")
    print("\n")

#Retourne si un tableau de jeu (non final) donné est valide ou non : c'est valide si winX et winO ne sont pas simultanément vrais
def values_valide(values):
    winX = False
    winO = False
    listeX = [i for i in range(9) if values[i] == "X"]
    listeO = [i for i in range(9) if values[i] == "O"]
    for ligne in [(0, 1, 2), (3, 4, 5), (6, 7, 8), (0, 3, 6), (1, 4, 7),
                  (2, 5, 8), (0, 4, 8), (2, 4, 6)]:
        winX = winX or all(x in listeX for x in ligne)
        winO = winO or all(x in listeO for x in ligne)
    return not (winX and winO)

#Retourne si un tableau est final valide, c'est un XOR de winX, winO et draw : un et un seul de ces états doit être vrai
def fin_valide(values):
    winX = False
    winO = False
    nb_vide = sum(1 for case in values if case=="")
    listeX = [i for i in range(9) if values[i] == "X"]
    listeO = [i for i in range(9) if values[i] == "O"]
    for ligne in [(0, 1, 2), (3, 4, 5), (6, 7, 8), (0, 3, 6), (1, 4, 7),
                  (2, 5, 8), (0, 4, 8), (2, 4, 6)]:
        winX = winX or all(x in listeX for x in ligne)
        winO = winO or all(x in listeO for x in ligne)
    draw = not(winX or winO) and nb_vide==0
    return (winX ^ winO) ^ draw

#Retourne le résultat d'un tableau final valide donné (le vainqueur, ou égalité)
def resultat_partie(values):
    resultat=""
    winX = False
    winO = False
    nb_vide = sum(1 for case in values if case=="")
    listeX = [i for i in range(9) if values[i] == "X"]
    listeO = [i for i in range(9) if values[i] == "O"]
    for ligne in [(0, 1, 2), (3, 4, 5), (6, 7, 8), (0, 3, 6), (1, 4, 7),
                  (2, 5, 8), (0, 4, 8), (2, 4, 6)]:
        winX = winX or all(x in listeX for x in ligne)
        winO = winO or all(x in listeO for x in ligne)
    draw = not(winX or winO) and nb_vide==0
    if winX: resultat="winX"
    if winO: resultat="winO"
    if draw: resultat="draw"
    return resultat

#Vérifie si un élément est déjà dans une liste
def deja_dans_liste(grille,liste_grilles):
    return grille in liste_grilles

#Fonction centrale : permet de générer en "bruteforce" toutes les parties valides de Morpion
def bruteforce_parties(parties,partie,values,tourX):
    #On définit les positions disponibles
    positions = [i for i in range(9) if values[i]==""]
    #Tant qu'il reste des positions valides, on va parcourir tous les scénarios de jeux possibles
    if (len(positions) > 0):
        #On va jouer successivement chacune des positions possibles
        for case in positions:
            #On recopie la grille
            cpy_values = values.copy()
            #Si c'est le tour de X, X joue sur case et si la partie n'est pas finie on rappelle la fonction avec O qui joue
            if (tourX):
                cpy_values[case] = "X"
                partie_new = partie+"X"+str(case)
                if (fin_valide(cpy_values)):
                    parties[partie_new] = cpy_values
                else:
                    bruteforce_parties(parties,partie_new,cpy_values,tourX=False)
            #Sinon c'est le tour de O, O joue case et si la partie n'est pas finie on rappelle la fonction avec X qui joue
            else:
                cpy_values[case] = "O"
                partie_new = partie+"O"+str(case)
                if (fin_valide(cpy_values)):
                    parties[partie_new] = cpy_values
                else:
                    bruteforce_parties(parties,partie_new,cpy_values,tourX=True)
    return parties


#On génère toutes les parties valides pour lesquelles X commence et on les enregistre dans une liste liste_parties
liste_parties=bruteforce_parties({},"",grille_vide,tourX=True)
#On ajoute à liste_parties toutes les parties où O commence
liste_parties.update(bruteforce_parties({},"",grille_vide,tourX=False))

# Sérialisation en JSON : c'était une mauvaise idée pour FPC
""" json_parties = json.dumps(liste_parties)

fic_parties = './parties.json'
with open(fic_parties, 'w') as file_object:
    file_object.write(json_parties)
 """
#On préfère un fichier csv simple, avec séparateur point-virgule, qui contient ainsi l'exhaustivité des parties valides de Morpion
fic_parties = './parties_valides.csv'
with open(fic_parties, 'w') as file_object:
    for k,v in liste_parties.items():
        #On enregistre 4 champs
        #-la partie exprimée en termes de coup avec d'abord le joueur (X ou O) puis la case jouée (de 0 à 8)
        #-l'état final de la grille
        #-le résultat de la partie (X gagne, O gagne ou draw)
        #-le nombre de coups joués
        #Certaines infos sont redondantes, mais peu importe vu que la taille du fichier reste raisonnable,
        #On préfère avoir à dispo toutes les infos dont on pourrait avoir besoin ensuite dans le programme de test Pascal 
        #sans avoir à faire de nouveaux calculs
        file_object.write(k + ";" + ",".join(v) + ";" + resultat_partie(v) + ";" + str(int(len(k)/2)) + "\n")


# print_tic_tac_toe(import_grille(206))
# -*- coding: utf-8 -*-


