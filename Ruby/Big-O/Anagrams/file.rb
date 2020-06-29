def insert_one(c, perm)
    ret = []
    (0..perm.length).each do |ins|
        ret << perm.dup.insert(ins, c)
    end

    ret
end

def insert_all(c, perms)
    ret = []
    perms.each {|p| ret += insert_one(c, p)}

    ret
end

def my_permutations(chars)
    return [chars] if chars.length == 1
    insert_all(chars.first, my_permutations(chars[1..-1]))
end

def first_anagram?(s1, s2)
    my_permutations(s1.chars).include?(s2.chars)
end

#print my_permutations(['a', 'b', 'c'])

# puts first_anagram?("gizmo", "sally")               # false
# puts first_anagram?("elvis", "lives")               # true
# puts first_anagram?("dan", "nad")                   # true
# puts first_anagram?("aaron", "aaron")               # true
# puts first_anagram?("theclassroom", "schoolmaster") # true

def second_anagram?(s1, s2)
    chars1, chars2 = s1.chars, s2.chars
    chars1.each do |c| 
        idx = chars2.find_index(c)
        return false if idx.nil?
        chars2.delete_at(idx)
    end

    return chars2.length == 0
    # doesn't the runtime of this depend on the implementation
    # of delete_at()???
end

# puts second_anagram?("gizmo", "sally")               # false
# puts second_anagram?("elvis", "lives")               # true
# puts second_anagram?("dan", "nad")                   # true
# puts second_anagram?("aaron", "aaron")               # true
# puts second_anagram?("theclassroom", "schoolmaster") # true
# puts second_anagram?("aaron", "aron")                # false
# puts second_anagram?("discriminator", "doctrinairism")# true

def third_anagram?(s1, s2)
    s1.chars.sort == s2.chars.sort
    # O(3n) => O(n)
    # sorting both, then checking equality
    # !!!! remember that sorting takes time!!!!!
end

# puts third_anagram?("gizmo", "sally")               # false
# puts third_anagram?("elvis", "lives")               # true
# puts third_anagram?("dan", "nad")                   # true
# puts third_anagram?("aaron", "aaron")               # true
# puts third_anagram?("theclassroom", "schoolmaster") # true
# puts third_anagram?("aaron", "aron")                # false
# puts third_anagram?("discriminator", "doctrinairism")# true

def fourth_anagram?(s1, s2)
    h1 = {}
    h2 = {}
    s1.chars.each {|c| h1[c] ? h1[c] += 1 : h1[c] = 1}
    s2.chars.each {|c| h2[c] ? h2[c] += 1 : h2[c] = 1}

    h1 == h2

    # assuming every letter is different, 2n + n hash value comparisons
end

# puts fourth_anagram?("gizmo", "sally")               # false
# puts fourth_anagram?("elvis", "lives")               # true
# puts fourth_anagram?("dan", "nad")                   # true
# puts fourth_anagram?("aaron", "aaron")               # true
# puts fourth_anagram?("theclassroom", "schoolmaster") # true
# puts fourth_anagram?("aaron", "aron")                # false
# puts fourth_anagram?("discriminator", "doctrinairism")# true

def fifth_anagram?(s1, s2)
    h = {}
    s1.chars.each {|c| h[c] ? h[c] += 1 : h[c] = 1}
    s2.chars.each {|c| h[c] ? h[c] -= 1 : h[c] = 1}

    h.values.all?(0)
end

puts fifth_anagram?("gizmo", "sally")               # false
puts fifth_anagram?("aabbaa", "ccddcc")              # false
puts fifth_anagram?("elvis", "lives")               # true
puts fifth_anagram?("dan", "nad")                   # true
puts fifth_anagram?("aaron", "aaron")               # true
puts fifth_anagram?("theclassroom", "schoolmaster") # true
puts fifth_anagram?("aaron", "aron")                # false
puts fifth_anagram?("discriminator", "doctrinairism")# true