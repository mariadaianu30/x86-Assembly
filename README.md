# Maria Daianu - x86-Assembly Project
# Overview
This project, developed as part of the "Arhitectura Sistemelor de Calcul" course, focuses on implementing memory management routines in x86 assembly language. The primary objective is to simulate a storage device's operations, managing memory blocks efficiently through various subprograms.
# Project Structure

132_Daianu_MariaIuliana_0.s: Contains the implementation for the unidimensional memory management system.

132_Daianu_MariaIuliana_1.s: Contains the implementation for the bidimensional memory management system.

# Project Scope&Requirements

The system manages a simulated storage memory in the form of a 1D or 2D array of blocks. 

The constraints and the implementation of the program are the following:
	-Each file is allocated contiguous memory blocks.
	-If contiguous space is unavailable, the allocation fails unless defragmentation is performed.
	-A bitmap-like structure may be used to keep track of free and occup
# Implementation of the system with unidimensional memory

In this unidimensional case, the way the storage device is required to function is as follows:

The storage capacity of the device is given and fixed at 8MB;
The storage capacity of the device is divided into blocks of 8kB each.

# Functionalities of the project

1. `Add( File Allocation)`
   Tries to find contiguos free blocks to store the files. If enough space is found we allocate the given number of blocks and update the memory. If not enough space is found, allocation fails.

2. `Get(File Retrieval)`
   Given a certain ID, the system retreives its starting memory block, the end of the memory blocka and displays its content.

3. `Delete(File Deallocation)`
   Frees up a space for future allocations based on the ID provided.
   
4.`Defragmentation(Memory Optimization)`
   Shifts all allocated blocks to the beggining of the memory by eliminating the gaps between blocks of memory.


# How to run the project
#### In order to execute the program, you must enter a series of commands in the Linux terminal. These commands will handle the assembly, linking, and running of the program. Open the terminal and navigate to the project folder. Below are the steps you need to follow:
1. gcc -m32 Gcc -m32 132_Daianu_MariaIuliana_0.s -o project0  -no-pie -g
2. ./project0

Do the same for 132_Daianu_MariaIuliana_1.s .




