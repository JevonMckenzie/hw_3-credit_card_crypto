require 'gsl'

module DoubleTranspositionCipher
  def self._swap(mat, iterations, rand_key, swap_rows)
    i = 0
    j = 2
    key_int = rand_key.rand(128)
    (0..key_int).each{
      if i == iterations-2
        i = 0
      end
      if swap_rows == true
        mat = mat.swap_rows(i,j+i)
      else
        mat = mat.swap_cols(i,j+i)
      end
      i += 1
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
    len = document.length
    rows = (len**0.5).round
    cols = (len/rows.to_f).round
    rand_key = Random.new(key)
    rand_key.rand(128)

    (len..rows*cols).each{|x|document[x] = '+'}
    content = document.split("").map{|c|c.ord}
    vec = GSL::Vector::Int.alloc(*content)
    mat = vec.matrix_view(rows,cols)
    mat = _swap(mat, rows, rand_key, true)
    mat = _swap(mat, cols, rand_key, false)
    encrypted_text = '';
    mat.to_v.each{|x|
      encrypted_text << x.chr
    }
    return encrypted_text
  end

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
