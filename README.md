# One Class Quantification

Supplemental material for the paper. Download link coming soon.

## IMPORTANT NOTES

Equation for the Overflow, used by ODIn, is wrong. We apologize for that.
The correct equation is the following:

![Overflow](/Overflow.svg)

## Current status

| Info              | Details                                                                      |
| ------------------|------------------------------------------------------------------------------|
| **Paper status**  | RELEASED                                                                     |
| **Download link** | _coming soon_                                                                |
| **DOI**           | _coming soon_                                                                |
| **URL**           | [CLICK HERE](http://www.ecmlpkdd2018.org/wp-content/uploads/2018/09/125.pdf) |

## Implementations

We provide implementations for

  - Passive Aggressive Threshold (PAT)
  - One Distribution Inside (ODIn)
  - HDy

The example file shows how to use all of them.
Execute with `luajit Example.lua`.

## Datasets

In this paper, we introduce one new dataset, _AllSpecies_ (referred to as Insects).
Class labels and features were obfuscated.
The dataset can be download [here](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/6J5BXV).


In our experiments, the positive class in the Insects dataset is class number 2.
The negative subclasses are 1, 3, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 20, 22, 24.
Other classes in the file are unused.

We are still arranging a citation format for this dataset.
If you are interest in using it, please, contact us so we can provide a proper way of citing us.
Until we arrange a standard way of citing us, please, do not publish this dataset or results obtained with it without contacting us, first.

We made use of several other datasets. We list all of them bellow, with proper links to ther sources.

 - [Spoken Arabic Digit](https://archive.ics.uci.edu/ml/datasets/Spoken+Arabic+Digit)
 - [Anuran Calls](https://archive.ics.uci.edu/ml/datasets/Anuran+Calls+%28MFCCs%29)
 - [Pen Based Recognition of Handwritten Digits](https://archive.ics.uci.edu/ml/datasets/Pen-Based+Recognition+of+Handwritten+Digits)
 - [HTRU2](https://archive.ics.uci.edu/ml/datasets/HTRU2)
 - [Wine Quality](https://archive.ics.uci.edu/ml/datasets/Wine+Quality)
 - [BNG Japanese Vowels](https://www.openml.org/d/1214)
 - [Letter](https://www.openml.org/d/6)
 - [Handwritten](https://github.com/denismr/Unsupervised-Context-Switch-For-Classification-Tasks)
