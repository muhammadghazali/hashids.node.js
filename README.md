
# hashids

A tiny Node.js JavaScript class to generate YouTube-like hashes from one or many ids.

## Contents

* **README.md** - documentation and examples
* LICENSE
* package.json
* index.js
* src/
	* **hashids.coffee** - hashids class written in CoffeeScript
* lib/
	* **hashids.js** - compiled hashids in JavaScript

## What's it for?

Generating **unique hashes** is beneficial when you do not want to expose your database ids in the URL. It's even more helpful when you do not have to look up in the database what record belongs to what hash.

Instead of storing these hashes in the database and selecting by them, you could encode primary ids and select by those - which is faster. Providing a unique `salt` value to the constructor will make your hashes unique also.

Hashes look similar to what YouTube, Bitly, and other popular websites have: `p9`, `pZsCB`, `qKuBQuxc`. They are case-sensitive, include alphanumeric characters and a dash by default.

(You can customize the alphabet from which your hashes are created.)

## What's different?

With this class you could encode several ids into one hash. If you have several objects to keep track of, you could use for example `userId`, `univesityId` and `classId` -- passing *all three ids* at the same time and getting back *one hash*.

This is really useful for complex or clustered systems where you need to remember more than one id.

There is no limit to how many ids you can encode into one hash. The more ids you provide and the bigger the numbers, the longer your hash will be.

## Installation

1. Grab [Node.js](http://nodejs.org/) and install if you haven't already: [http://nodejs.org/#download](http://nodejs.org/#download)
2. Same with [npm](http://npmjs.org/) (package manager for Node).
3. Install [hashids](http://hashids.org/):
	
	`npm install -g hashids`
	
## Sample Usage

All integers are expected to be positive.

### Encoding:

To encode a single number:
	
```javascript
var hashids = require('hashids');
hashids = new hashids('this is my salt');

var hash = hashids.encode(12345);
```

var `hash` is now going to be:

	7OR

To encode multiple numbers into one hash:
	
```javascript
var hashids = require('hashids');
hashids = new hashids('this is my salt');

var hash = hashids.encode(683, 94108, 123, 5);
```

var `hash` is now going to be:
	
	nEfOM6s2oIz
	
### Decoding:

Hash decoding is done using the same salt value that you have used during encoding:

```javascript
var hashids = require('hashids');
hashids = new hashids('this is my salt');

var hash1 = hashids.decode('7OR');
console.log(hash1);

var hash2 = hashids.decode('nEfOM6s2oIz');
console.log(hash2);
```

Output will be:

```javascript
[ 12345 ]
[ 683, 94108, 123, 5 ]
```

## Security

The primary purpose of hashids is to make ids look different. It's not meant or tested to be used as a security algorithm.

Having said that, this class does try to make these hashes un-guessable and unique.

Let's look at the following example:

```javascript
var hashids = require('hashids');
hashids = new hashids('this is my salt');

var hash = hashids.encode(5, 5, 5, 5);
```

var `hash` will be:
	
	jie1ws6
	
You don't see any repeating patterns that might show there's 4 identical numbers in the hash.

Same with incremented numbers:

```javascript
var hashids = require('hashids');
hashids = new hashids('this is my salt');

var hash = hashids.encode(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
```

var `hash` will be :
	
	6utsaI616snh0SdFthj
	
## Bonus

Since these hashes are most likely to be used in user-visible places, like the url -- no matter the salt value, they should not make up basic curse words by design, like the f-bomb or "#2".