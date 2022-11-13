// Require mongoose type model 
const mongoose = require('mongoose');

// Define notes object 
const Note = mongoose.model('Note', {
    note: {
        type: String 
    }
})

// Exports Note Model
module.exports = Note