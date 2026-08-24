import type { Settings } from "../models/types";

export const seedSettings: Settings = {
  contactEmail: "support@lumamarine.se",
  contactPhone: "+46 8 123 456 78",
  openingHours: {
    sv: "Mån–fre 09:00–17:00. Stängt på röda dagar.",
    en: "Mon–Fri 9:00 AM–5:00 PM. Closed on public holidays.",
    no: "Man–fre 09:00–17:00. Stengt på helligdager.",
    da: "Man.–fre. 09:00–17:00. Lukket på helligdage.",
  },
  banners: [
    {
      id: "banner-launch",
      message: {
        sv: "Nyhet! Nu i butiken — utforska hela vårt sortiment av marin LED-belysning.",
        en: "New! Now in the shop — explore our full range of marine LED lighting.",
        no: "Nytt! Nå i butikken — utforsk hele sortimentet av marin LED-belysning.",
        da: "Nyt! Nu i butikken — udforsk hele vores sortiment af marin LED-belysning.",
      },
      startDate: "2026-01-01",
      endDate: "2026-12-31",
      active: true,
    },
  ],
  updatedAt: "2026-08-24T00:00:00.000Z",
};
