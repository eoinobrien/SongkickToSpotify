import { PlaylistComponentProps } from '.';
import styles from './Playlist.module.css';
import { PlaylistType } from './Playlist.types';

export const Playlist: React.FC<PlaylistComponentProps> = ({
  playlist,
}: PlaylistComponentProps) => {
  const imagePath = (playlistType: PlaylistType, area: string) => {
    const path = `${playlistType}/${area}.jpg`
      .split(`,`)
      .join(``)
      .split(` `)
      .join(``);

    try {
      // eslint-disable-next-line import/no-dynamic-require, global-require
      require(`./cover-art/${path}`);
      return path;
    } catch {
      return `${playlistType}/Backup.jpg`;
    }
  };

  return (
    <div className={styles.playlist}>
      <a
        href={`https://open.spotify.com/playlist/${playlist.PlaylistId}`}
        target="_blank"
        className={styles.spotify}
        rel="noreferrer"
      >
        <picture>
          <source
            // eslint-disable-next-line import/no-dynamic-require, global-require
            srcSet={require(`./cover-art/${imagePath(
              playlist.PlaylistType,
              playlist.Area,
            )}?webp`)}
            type="image/webp"
          />
          <source
            // eslint-disable-next-line import/no-dynamic-require, global-require
            srcSet={require(`./cover-art/${imagePath(
              playlist.PlaylistType,
              playlist.Area,
            )}`)}
            type="image/jpeg"
          />
          <img
            // eslint-disable-next-line import/no-dynamic-require, global-require
            src={require(`./cover-art/${imagePath(
              playlist.PlaylistType,
              playlist.Area,
            )}`)}
            alt={playlist.PlaylistTitle}
            className={styles.coverArt}
            width="200"
            height="200"
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
};
