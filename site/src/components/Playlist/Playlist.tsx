import Image from 'next/image';
import { PlaylistComponentProps } from '.';
import styles from './Playlist.module.css';

export const Playlist: React.FC<PlaylistComponentProps> = ({
  playlist,
}: PlaylistComponentProps) => {
  return (
    <div className={styles.playlist}>
      <a
        href={'https://open.spotify.com/playlist/' + playlist.PlaylistId}
        target="_blank"
        className={styles.spotify}
      >
        <picture>
          <source
            srcSet={require(`./cover-art/${playlist.PlaylistTitle}.jpg?webp`)}
            type="image/webp"
          />
          <source
            srcSet={require(`./cover-art/${playlist.PlaylistTitle}.jpg`)}
            type="image/jpeg"
          />
          <img
            src={require(`./cover-art/${playlist.PlaylistTitle}.jpg`)}
            alt={playlist.PlaylistTitle}
            className={styles.coverArt}
          />
        </picture>
        <h2 className={styles.spotifyButton}>Play on Spotify</h2>
      </a>
      <a
        href={'https://www.songkick.com/metro-areas/' + playlist.MetroId}
        target="_blank"
        className={styles.songkick}
      >
        See concerts on Songkick
      </a>
    </div>
  );
};
