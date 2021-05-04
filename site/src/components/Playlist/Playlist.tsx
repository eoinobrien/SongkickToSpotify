import { PlaylistComponentProps } from '.';
import styles from './Playlist.module.css';

export const Playlist: React.FC<PlaylistComponentProps> = ({
  playlist,
}: PlaylistComponentProps) => (
  <div className={styles.playlist}>
    <a
      href={`https://open.spotify.com/playlist/${playlist.PlaylistId}`}
      target="_blank"
      className={styles.spotify}
      rel="noreferrer"
    >
      <picture>
        <source
          srcSet={require(`./cover-art/${playlist.PlaylistTitle}.jpg?webp`)} // eslint-disable-line import/no-dynamic-require, global-require
          type="image/webp"
        />
        <source
          srcSet={require(`./cover-art/${playlist.PlaylistTitle}.jpg`)} // eslint-disable-line import/no-dynamic-require, global-require
          type="image/jpeg"
        />
        <img
          src={require(`./cover-art/${playlist.PlaylistTitle}.jpg`)} // eslint-disable-line import/no-dynamic-require, global-require
          alt={playlist.PlaylistTitle}
          className={styles.coverArt}
        />
      </picture>
      <h2 className={styles.spotifyButton}>Play on Spotify</h2>
    </a>
    <a
      href={`https://www.songkick.com/metro-areas/${playlist.MetroId}`}
      target="_blank"
      className={styles.songkick}
      rel="noreferrer"
    >
      See concerts on Songkick
    </a>
  </div>
);
