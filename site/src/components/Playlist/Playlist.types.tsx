export type PlaylistComponentProps = PlaylistProps;

export type PlaylistProps = {
  playlist: PlaylistCity;
  source?: string;
};

export enum PlaylistType {
  Upcoming = `Upcoming`,
  Tonight = `Tonight`,
}

export type PlaylistCity = {
  PlaylistId: string;
  PlaylistType: PlaylistType;
  Offset: number;
  PlaylistTitle: string;
  Area: string;
  MetroId: string;
  PhotoCredit: string;
};
