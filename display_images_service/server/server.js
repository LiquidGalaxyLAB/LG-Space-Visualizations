const express = require('express');
const app = express();
const port = 58607;

app.use(express.static('public'));

app.get('/display', (req, res) => {
  const { photo_url, current_screen, total_screen } = req.query;

  if (!photo_url || !current_screen || !total_screen) {
    return res.status(400).send('Missing parameters');
  }

  res.sendFile(__dirname + '/public/index.html');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
