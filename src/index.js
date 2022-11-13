// Import packages 
// Using our express package 
const express = require('express');

// To read of data, we need to use fs framework
const fs = require('fs');

// To initiate mongoose once 
require('./db/mongoose')

// To initiate model of note
const Note = require('./models/note')

// Initiate express by creating a constant app 
const app = express();

// Instantiate app and using express framework
app.use(express.json()) 

// Post request by creating a new note 
app.post('/notes', async (req, res) => {
    const note = new Note(req.body)

    try {
        await note.save()
        res.status(201).send(note)
    }
    catch (err) {
        res.status(400).send(err)
    }
})

// Get request to fetch data from server
app.get('/notes', async (req, res) => {
    
    try {
        const notes = await Note.find({})
        res.send(notes)
    }
    catch (err) {
        res.status(500).send(err)
    }


})

// Update Data from database
app.patch('/notes/:id', async (req, res) => {

try{
    const note = await Note.findById(req.params.id)

    if (!note) {
        return res.status(404).send()
    }

    note.note = req.body.note

    await note.save()

    res.status(200).send(note)
}
catch (err) {
    res.status(404).send(err)
}
})

// Delete Data from database
app.delete('/notes/:id', async (req, res) => {
    try {
    const note = await Note.findByIdAndDelete(req.params.id)

    if (!note) {
        return res.status(404).send()
    }

    res.send("The note has been deleted")
}
catch (err) {
    res.status(500).send(err)
}

})

// api has to listen to a specific port. 
app.listen(3000, () => {
    console.log("Server is up on port 3000")
})