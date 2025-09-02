import React, { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  const [movies, setMovies] = useState([]);
  const [selectedMovie, setSelectedMovie] = useState(null);
  const [userName, setUserName] = useState('');
  const [seats, setSeats] = useState(1);

  useEffect(() => {
    axios.get('movie-app-lb-2048527481.ap-south-1.elb.amazonaws.com/movies') // Update to backend URL in prod
      .then(res => setMovies(res.data))
      .catch(err => console.error(err));
  }, []);

  const handleBook = () => {
    if (!selectedMovie) return;
    axios.post('movie-app-lb-2048527481.ap-south-1.elb.amazonaws.com/book', { // Update to backend URL in prod
      movie_id: selectedMovie.id,
      user_name: userName,
      seats
    })
      .then(res => alert(res.data.message))
      .catch(err => console.error(err));
  };

  return (
    <div>
      <h1>Movie Ticket Booking</h1>
      <h2>Movies</h2>
      <ul>
        {movies.map(movie => (
          <li key={movie.id} onClick={() => setSelectedMovie(movie)}>
            {movie.title} - {new Date(movie.show_time).toLocaleString()}
          </li>
        ))}
      </ul>
      {selectedMovie && (
        <div>
          <h3>Book for {selectedMovie.title}</h3>
          <input
            type="text"
            placeholder="Your Name"
            value={userName}
            onChange={e => setUserName(e.target.value)}
          />
          <input
            type="number"
            value={seats}
            onChange={e => setSeats(e.target.value)}
            min="1"
          />
          <button onClick={handleBook}>Book</button>
        </div>
      )}
    </div>
  );
}

export default App;
