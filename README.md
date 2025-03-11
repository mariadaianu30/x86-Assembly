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
