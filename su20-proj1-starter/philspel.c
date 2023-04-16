/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */

  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  // -- TODO --
  unsigned int hashcode = 0;
  while (*string){
    hashcode += hashcode*17 + *string;
    string ++;
  }

  return hashcode;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  if (strcmp(string1, string2) == 0)  
    return 1;
  else                                
    return 0;  
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE* f = fopen(dictName, "r");
  int cnt = 0;
  int size = 60;
  char* buffer = (char *)malloc(sizeof(char) *  size);  // create a size char buffer
  char* string;
  char c;
  if (f == NULL){
    fprintf(stderr, "File not exisits.");
    exit(1);
  }
  while((c = fgetc(f)) != EOF){
    if (c == ' ')
      continue;
    buffer[cnt] = c;
    cnt ++;
    if(c == '\n') {
      buffer[cnt-1] = '\0';
      string = (char*)malloc(sizeof(char) * cnt);
      strncpy(string, buffer, cnt);
      if (findData(dictionary, (void*)string) == NULL) 
        insertData(dictionary, string, string);
      cnt = 0;
    }
    if (cnt >= size * 2 / 3){
      size *= 2;
      buffer = realloc(buffer, size * 2);
    }
  }
  free(buffer);
  fclose(f);
  return;
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
  char c;
  int i = 0;
  int total_size = 60;
  char * word = (char *) malloc(sizeof(char) * total_size);
  char * all_but_first_lowercase = (char *) malloc(sizeof(char) * total_size);
  char * all_lowercase = (char *) malloc(sizeof(char) * total_size);

  while ((c = fgetc(stdin)) != EOF)
  {
    if (isalpha(c)) {
      word[i++] = c;
      if (i == total_size) {
        total_size *= 2;
        word = (char *) realloc(word, sizeof(char) * total_size);
        all_but_first_lowercase = (char *) realloc(all_but_first_lowercase, sizeof(char) * total_size);
        all_lowercase = (char *) realloc(all_lowercase, sizeof(char) * total_size);
      }
    } else {
      if (i == 0) {
        fprintf(stdout, "%c", c);
        continue;
      }
      word[i] = '\0';
      for (int j = 0; j < strlen(word); j++) {
        if (j == 0) {
          all_but_first_lowercase[j] = word[j];
          all_lowercase[j] = tolower(word[j]);
        } else {
          all_but_first_lowercase[j] = tolower(word[j]);
          all_lowercase[j] = tolower(word[j]);
        }
      }
      if (findData(dictionary, word) || findData(dictionary, all_but_first_lowercase) || findData(dictionary, all_lowercase)) {
        fprintf(stdout, "%s", word);
      } else {
        fprintf(stdout, "%s [sic]", word);
      }
      fprintf(stdout, "%c", c);
      i = 0;
      total_size = 60;
      word = (char *) malloc(sizeof(char) * total_size);
      all_but_first_lowercase = (char *) malloc(sizeof(char) * total_size);
      all_lowercase = (char *) malloc(sizeof(char) * total_size);
    }
  }
  if (i == 0) {
    return;
  } else {
    word[i] = '\0';
    for (int j = 0; j < strlen(word); j++) {
      if (j == 0) {
        all_but_first_lowercase[j] = word[j];
        all_lowercase[j] = tolower(word[j]);
      } else {
        all_but_first_lowercase[j] = tolower(word[j]);
        all_lowercase[j] = tolower(word[j]);
      }
    }
    if (findData(dictionary, word) || findData(dictionary, all_but_first_lowercase) || findData(dictionary, all_lowercase)) {
      fprintf(stdout, "%s", word);
    } else {
      fprintf(stdout, "%s [sic]", word);
    }
  }
  free(word);
  free(all_but_first_lowercase);
  free(all_lowercase);
      
  return;
}
