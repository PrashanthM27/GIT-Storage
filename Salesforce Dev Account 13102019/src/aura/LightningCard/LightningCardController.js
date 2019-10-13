({
    init: function (component) {
        var sections = [
            {
                label: "Reports",
                items: [
                    {
                        label: "Created by Me",
                        name: "default"
                    },
                    {
                        label: "Public Reports",
                        name: "public"
                    }
                ]
            },
            {
                label: "Dashboards",
                items: [
                    {
                        label: "Favorites",
                        name: "favourite",
                        icon: "utility:favorite"
                    },
                    {
                        label: "Most Popular",
                        name: "custom"
                    }
                ]
            }
        ];
        component.set('v.navigationData', sections);
    }
})