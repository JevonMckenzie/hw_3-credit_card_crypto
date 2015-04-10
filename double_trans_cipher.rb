require 'gsl' #requiring GSL library to use swap rows() and swap cols()

module DoubleTranspositionCipher
  def self._swap(mat, iterations, rand_key, swap_rows) #defining method to swap rows and columns specified by a random number
    i = 0 
            #initializing counters to swap rows and columns
    j = 2
    key_int = rand_key.rand(128)  #assigning random number to key_int
    (0..key_int).each{            #entering loop, controlled by random variable/number
      if i == iterations-2        #check to see if counter has reached the end of the matrix
        i = 0                     #if counter reached the end, setting counter to continue swapping from begining of matrix
      end
      if swap_rows == true
        mat = mat.swap_rows(i,j+i)  #using GSL function swap_rows() to swap rows
      else
        mat = mat.swap_cols(i,j+i)  #using GSL function swap_cols() to swap cols
      end
      i += 1          #incrementing counter to allow subsequent columns and rows to swap
    }
    return mat
  end

  def self.encrypt(document, key)
    # TODO: FILL THIS IN!
    ## Suggested steps for double transposition cipher
    # 1. find number of rows/cols such that matrix is almost square
    # 2. break plaintext into evenly sized blocks
    # 3. sort rows in predictibly random way using key as seed
    # 4. sort columns of each row in predictibly random way
    # 5. return joined cyphertext
    len = document.length         #assigning length of document to len
    rows = (len**0.5).round       #finding the square root of the len and assigning the rounded value to rows
                                  #finding the two closest factors to len(lenght of document) to get dimensions matrix
    cols = (len/rows.to_f).round  #finding the numbers of clomuns
    rand_key = Random.new(key)    #passing key as seed to generate random variable
    rand_key.rand(128)            #generating random variable

    (len..rows*cols).each{|x|document[x] = '+'} #assigning the character '+' to padd the matrix 
    content = document.split("").map{|c|c.ord}  #creating array to store the ascii representation of the characters from the document
      #Note: did so because GSL matrix only stores floating point representation(cannot represent chars in floating point)
    vec = GSL::Vector::Int.alloc(*content)      #using GSL vector to convert the the matrix floating point elements to integer
                                                #and using (*), i.e. *content to pass elements of matrix to vec
    mat = vec.matrix_view(rows,cols)            #assigning the rows and columns to form matrix named mat
    mat = _swap(mat, rows, rand_key, true)      #parameter for method self._swap
    mat = _swap(mat, cols, rand_key, false)     #parameter for method self._swap
    encrypted_text = '';                        
    mat.to_v.each{|x|                         #looping through matrix and converting each integer to a character
      encrypted_text << x.chr
    }
    return encrypted_text
  end
  #because using the same seed (key) in random generator generates the same random number,
  #the decrypt is just the opposite of encrypt using the same seed (key)
  def self.decrypt(ciphertext, key)
    # TODO: FILL THIS IN!
    len = ciphertext.length
    rows = (len**0.5).round
    cols = (len/rows.to_f).round
    rand_key = Random.new(key)
    rand_key.rand(128)

    content = ciphertext.split("").map{|c|c.ord}
    vec = GSL::Vector::Int.alloc(*content)
    mat = vec.matrix_view(rows,cols)
    mat = _swap(mat, rows, rand_key, true)
    mat = _swap(mat, cols, rand_key, false)
    plain_text = '';
    mat.to_v.each{|x|
      plain_text << x.chr
    }
    plain_text.gsub!(/[+]/, '')
    return plain_text
  end
end

#enc_text =  DoubleTranspositionCipher::encrypt('today is a good day',89);
#plain_text =  DoubleTranspositionCipher::decrypt(enc_text,89);
#print enc_text, "\n"
#print plain_text, "\n"
