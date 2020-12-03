


from pastml.tree import read_tree, remove_certain_leaves
import ete3


if '__main__' == __name__:
    import argparse

    parser = argparse.ArgumentParser()

    parser.add_argument('--input_tree',  required=True, type=str)
    parser.add_argument('--output_bats',  required=True, type=str)
    parser.add_argument('--output_skunks',  required=True, type=str)
    parser.add_argument('--output_dogs',  required=True, type=str)
    parser.add_argument('--output_arctic_foxes', required=True, type=str)

    params = parser.parse_args()

    tree = read_tree(params.input_tree)

    #Hard coded definitions of where the node separating bats should be
    ancestor_bats = tree.get_common_ancestor("JQ685920", "JQ685966")
    #Get all tree leaves that are children to this node
    leaves_bats = ancestor_bats.get_leaves()

    #Save the tree leaves in a text file separate by new lines
    #with open("bats.txt", "w") as file:
    with open(params.output_bats, "w") as file:
        for leaf in leaves_bats:
            file.write(leaf.name)
            file.write('\n')

    #Hard coded definitions of where the node separating skunks should be
    ancestor_skunks = tree.get_common_ancestor("MN862283", "MF143371")
    #Get all tree leaves that are children to this node
    leaves_skunks = ancestor_skunks.get_leaves()

    # Save the tree leaves in a text file separate by new lines
    #with open("skunks.txt", "w") as file:
    with open(params.output_skunks, "w") as file:
        for leaf in leaves_skunks:
            file.write(leaf.name)
            file.write('\n')

    #Hard coded definitions of where the node separating dogs should be
    ancestor_dogs = tree.get_common_ancestor("KX148246", "MK598368")
    #Get all tree leaves that are children to this node
    leaves_dogs = ancestor_dogs.get_leaves()

    # Save the tree leaves in a text file separate by new lines
    #with open("dogs.txt", "w") as file:
    with open(params.output_dogs, "w") as file:
        for leaf in leaves_dogs:
            file.write(leaf.name)
            file.write('\n')

    ancestor_arctic_foxes = tree.get_common_ancestor("KU198462", "MN233943")
    # Get all tree leaves that are children to this node
    leaves_arctic_foxes = ancestor_arctic_foxes.get_leaves()

    # Save the tree leaves in a text file separate by new lines
    # with open("arctic_foxes.txt", "w") as file:
    with open(params.output_arctic_foxes, "w") as file:
        for leaf in leaves_arctic_foxes:
            file.write(leaf.name)
            file.write('\n')




