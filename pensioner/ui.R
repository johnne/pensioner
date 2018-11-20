library(shiny)
library(data.table)

###############################
## Define UI for application ##
###############################
ui <- fluidPage(
  
  titlePanel("Klimatsmarta Pensioner"),
  
  sidebarLayout(
    
    sidebarPanel(
      tags$h3("Information"),
      tags$ul(
        tags$li("Verktyget är ej optimerat för mobilskärmar"),
        tags$li("Bokstäverna ÅÄÖ kan ibland falla bort ur text och skapa problem för vissa fonder")),
      tags$i("Rapportera gärna eventuella problem till: "),
      tagList(a("john.sundh@gmail.com", href="mailto:john.sundh@gmail.com")),
      tags$hr(),
      tags$h3("Din fond idag:"),
      tags$i("Du hittar din fond på Pensionsmyndigheten "),
      tagList(a("Mina Sidor", href="https://idpproxy.pensionsmyndigheten.se/idp/profile/SAML2/Redirect/SSO?execution=e1s1")),
      tags$br(),
      tags$i("Logga in och gå sedan till din "),
      tagList(a("Fondportfölj",href="https://www.pensionsmyndigheten.se/service/fondportfolj/")),
      uiOutput("select_fund"),
      uiOutput("your_fund_infotext"),
      uiOutput("your_fund_name"),
      uiOutput("your_fund_etisk"),
      uiOutput("your_fund_avgift"),
      uiOutput("your_fund_fondtyp"),
      uiOutput("your_fund_risk"),
      uiOutput("your_fund_ydev"),
      uiOutput("your_fund_y5dev"),
      uiOutput("your_fund_avoids"),
      uiOutput("your_fund_comment_info"),
      uiOutput("your_fund_kluster_comm"),
      uiOutput("your_fund_kemiska_comm"),
      uiOutput("your_fund_nuclear_comm"),
      uiOutput("your_fund_vapen_comm"),
      uiOutput("your_fund_alkohol_comm"),
      uiOutput("your_fund_tobak_comm"),
      uiOutput("your_fund_spel_comm"),
      uiOutput("your_fund_porr_comm"),
      uiOutput("your_fund_fossilt_comm"),
      uiOutput("your_fund_kol_comm"),
      uiOutput("your_fund_uran_comm"),
      uiOutput("your_fund_other_comm"),
      uiOutput("your_fund_link_info"),
      uiOutput("your_fund_ppm"),
      uiOutput("your_fund_hprof"),
      tags$hr(),
      tags$h3("Hitta fonder som:"), 
      
      checkboxGroupInput("samma", label="Har samma", inline = TRUE,
                         choices = c("Risk","Fondtyp"), selected = c("Risk","Fondtyp")),
      checkboxGroupInput("criteria", label="Undviker", inline = TRUE,
                         choices = c("Samtliga av nedan","Klusterbomber","Kemiska vapen","Kärnvapen","Vapen/krigsmateriel","Alkohol",
                         "Tobak","Spelverksamhet","Pornografi","Fossilt","Kol","Uran","GMO")),
      
      tags$hr(),
      tags$h3("Bäst matchande fond:"),
      tags$i("Nedan visas fonden med lägst avgift som matchar"),
      tags$br(),
      tags$i("Om fler fonder matchar visas de i tabellen till höger ->>"),
      tags$br(),
      uiOutput("closest_fund_infotext"),
      uiOutput("closest_fund_name"),
      uiOutput("closest_fund_etisk"),
      uiOutput("closest_fund_avgift"),
      uiOutput("closest_fund_fondtyp"),
      uiOutput("closest_fund_risk"),
      uiOutput("closest_fund_ydev"),
      uiOutput("closest_fund_y5dev"),
      uiOutput("closest_fund_avoids"),
      uiOutput("closest_fund_comment_info"),
      uiOutput("closest_fund_kluster_comm"),
      uiOutput("closest_fund_kemiska_comm"),
      uiOutput("closest_fund_nuclear_comm"),
      uiOutput("closest_fund_vapen_comm"),
      uiOutput("closest_fund_alkohol_comm"),
      uiOutput("closest_fund_tobak_comm"),
      uiOutput("closest_fund_spel_comm"),
      uiOutput("closest_fund_porr_comm"),
      uiOutput("closest_fund_fossilt_comm"),
      uiOutput("closest_fund_kol_comm"),
      uiOutput("closest_fund_uran_comm"),
      uiOutput("closest_fund_other_comm"),
      uiOutput("closest_fund_link_info"),
      uiOutput("closest_fund_ppm"),
      uiOutput("closest_fund_hprof")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Jämfor fonder",
          DT::dataTableOutput("fund_table")
        ),
        tabPanel(title = "Så här byter du fonder",
          tags$br(),    
          tags$b(tagList(a("1. Klicka här for att komma till Mina sidor pa pensionsmyndigheten.se. Logga in med BankID eller Mobilt BankID", href="https://idpproxy.pensionsmyndigheten.se/idp/profile/SAML2/Redirect/SSO?execution=e2s1"))),
          tags$br(),
          tags$b(tagList(a("2. Gå till sidan för att byta fonder: https://www.pensionsmyndigheten.se/mina-tjanster/fondtorg/fondbyte", href="https://www.pensionsmyndigheten.se/mina-tjanster/fondtorg/fondbyte"))),
          tags$br(),
          tags$b("3. Sök upp den fond du vill byta till och klicka på '+'-tecknet för att lägga till den i din portfölj"),
          tags$br(),
          tags$b("4. Fördela andelar för fonderna i % och klicka sedan pa 'Gå vidare'"),
          tags$br(),
          tags$b("5. Signera. Klart!")
        ),
        tabPanel(title = "Om verktyget",
          tags$br(),
          tags$b("All information om fonder är hämtad fran Pensionsmyndighetens fondkatalog (2018) samt från hallbarhetsprofilen.se"),
          tags$br(),
          tags$b("För frågor/buggrapporter kontakta: "),
          tagList(a("john.sundh@gmail.com", href="mailto:john.sundh@gmail.com"))
        )
      )
    )
  )
)
