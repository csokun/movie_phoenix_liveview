# Movie Catalog

I'm a movie collector before we subscribe to Netflix. In those days, I like to organize my downloaded or encoded movies by folder.

```bash
catalog/
├── movie-1
│   ├── movie-1.jpg
│   ├── movie-1.jpg
│   └── metadata.json
└── movie-2
    ├── movie-2.jpg
    ├── movie-2.jpg
    └── metadata.json
```

As you can see, 1 folder/movie and each folder has minimum 2 files *.jpg for movie cover and *.mp4 you guess.
So my catalog system is very simple. Later, I started to add `metadata.json` so I can update more detail to my collection.

  - artist
  - production
  - plot
  - tags etc

Why `metadata.json`? I store my movies collection on external HDD and I want plug and play.

 - Connect external HDD
 - Launch a command to serve my catalog
 - Start watching my favorite movie

I can setup a `docker-compose.yaml` and persist my collection and what not; but really?

## How to get start

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


