
# hashids 0.1.1
# (c) 2012 Ivan Akimov
# https://github.com/ivanakimov/hashids.js
# hashids may be freely distributed under the MIT license.

# coffee -o lib/ -cwb src/

module.exports = class hashids
	
	constructor: (@salt, @alphabet = "-023456789abdegjklmnopqrtvwxyzABDEGJKLMNOPQRTVWXYZ", @separators = "1fFuUsSiIcChH") ->
		
		@crypto = require 'crypto'
		@alphabetLength = @alphabet.length
		
		@alphabet = @shuffle @alphabet, @salt if @salt.length
		
		# check that alphabet is unique
		
		collection = []
		for char in @alphabet
			if not collection[char]
				collection[char] = true
			else
				throw new Error 'Warning: Alphabet contains duplicate characters.'
		
		# check that separators are unique
		
		collection = []
		for char in @separators
			if not collection[char]
				collection[char] = true
			else
				throw new Error 'Warning: Separator string contains duplicate characters.'
		
		# check that separators do not exist in alphabet
		
		for char in @separators
			if @alphabet.indexOf(char) != -1
				throw new Error 'Warning: Separator characters cannot be part of the alphabet.'
		
	encode: () ->
		@encodeHash.apply this, arguments
		
	decode: (hash) ->
		@decodeHash hash
		
	encodeHash: () ->
		
		hash = ''
		alphabet = @alphabet
		args = Array.prototype.slice.call arguments
		
		for number, i in arguments
			
			if number < 0
				hash = ''
				break
			
			if i
				parameters = args.slice 0, i
				hash += @getSeparator.apply this, parameters
			
			subHash = @hash number, alphabet
			hash += subHash
			
			alphabet = @shuffle alphabet, @salt + subHash
			
		hash
		
	decodeHash: (hash) ->
		
		numbers = []
		alphabet = @alphabet
		
		hash = hash.trim()
		if hash
			
			subHash = hash
			subHash = subHash.replace(new RegExp(c, 'g'), ' ') for c in @separators
			hashArray = subHash.split ' '
			
			for subHash, i in hashArray
				if subHash
					
					number = @unhash subHash, alphabet
					numbers.push number
					
					if i + 1 < hashArray.length
						alphabet = @shuffle alphabet, @salt + subHash
				
		numbers
		
	hash: (number, alphabet) ->
		
		hash = ''
		alphabetLength = alphabet.length
		
		while number
			hash = alphabet[number % alphabetLength] + hash
			number = parseInt number / alphabetLength
		
		hash
		
	unhash: (hash, alphabet) ->
		
		ret = 0
		for char, i in hash
			pos = alphabet.indexOf char
			ret += pos * Math.pow alphabet.length, hash.length - i - 1
		
		ret
		
	shuffle: (alphabet, salt) ->
		
		shuffledAlphabet = ''
		sorting = @crypto.createHash('md5').update(salt).digest 'hex'
		
		i = 0
		while alphabet.length
			
			alphabetLength = alphabet.length
			
			pos = parseInt sorting[i], 16
			if pos >= alphabetLength
				pos = (alphabetLength - 1) % pos
			
			shuffledAlphabet += alphabet[pos]
			alphabet = alphabet.slice(0, pos) + alphabet.slice(pos + 1)
			
			i++
			i %= sorting.length
		
		shuffledAlphabet
		
	getSeparator: () ->
		
		sum = @alphabetLength
		sum += argument for argument in arguments
		
		i = sum % (@separators.length - 1)
		@separators[i]
	