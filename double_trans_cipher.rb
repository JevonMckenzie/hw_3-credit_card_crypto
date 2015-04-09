module DoubleTranspositionCipher
  def self.gen_mapping(doc_len, factor, key, reversed = false)
    num_gen = Random.new(key.to_i)
    mapping = (0..doc_len / factor - 1).to_a.shuffle(random: num_gen).product((0..factor - 1).to_a.shuffle(random: num_gen)).map { |pair| pair.first * factor + pair.last }
    mapping = Hash[mapping.zip((0..doc_len - 1).to_a)] if reversed
    mapping
  end

  def self.encrypt(document, key)
    doc_str = document.to_s
    ((doc_str.length**0.5).to_i..doc_str.length).each do |num|
      next if doc_str.length % num != 0
      mapping = gen_mapping(doc_str.length, num, key)
      return doc_str.chars.each_with_index.map do |_, index|
        doc_str[mapping[index]]
      end.join
    end
  end

  def self.decrypt(ciphertext, key)
    cip_str = ciphertext.to_s
    ((cip_str.length**0.5).to_i..cip_str.length).each do |num|
      next if cip_str.length % num != 0
      mapping = gen_mapping(cip_str.length, num, key, true)
      return cip_str.chars.each_with_index.map do |_, index|
        cip_str[mapping[index]]
      end.join
    end
  end
end
