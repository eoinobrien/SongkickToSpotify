import Image from 'next/image'
import { PlaylistComponentProps } from '.';
import styles from './Playlist.module.css';

export const Playlist: React.FC<PlaylistComponentProps> = (
  props: PlaylistComponentProps,
) => {
  return (
    <div className={styles.playlist}>
      <Image
        src={'/cover-art/' + props.playlist.PlaylistTitle + '.jpg'}
        alt={'Playlist cover art for ' + props.playlist.PlaylistTitle + '.'}
        width={200}
        height={200}
        className={styles.coverArt}
      />
      <a
        href={'https://open.spotify.com/playlist/' + props.playlist.PlaylistId}
        target="_blank"
      >
        Play on Spotify
      </a>
      <a
        href={'https://www.songkick.com/metro-areas/' + props.playlist.MetroId}
        target="_blank"
      >
        See concerts on Songkick
      </a>
    </div>
  );
};
