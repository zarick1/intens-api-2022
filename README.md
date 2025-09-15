# Intens Api DevOps
Uputstvo za izradu.

## Koraci
1. Forkovati repozitorijum
2. Pokrenuti api lokalno koristeci alat po izboru (dodati env variablu PORT i dodeliti vrednost 8080 ili bilo koji drugi dostupan port)
3. Napisati Dockerfile (5 bodova)
4. Upraditi deploy apia na bilo koji cloud provider, moze i docker / kubernetes lokalno (5 bodova)
5. Implemetirati CI CD koristeci GitHub Actions, potrebno je kreirati dve ci cd skripte. Prva skripta treba da se pokrece automatski prilikom kreiranja PR nad master granom i treba da izvrsi testove. 2. skripta treba da se pokrece automatski prilikom pusha na master granu i treba da izvrsava build apia, pakovanje i odlaganje docker slike na repo po zelji i zamenu stare za novu sliku na odabranom cloud provideru ili lokalu. (10 bodova)
6. Na email poslati url vaseg git repoa kao i url otpremljenog apia na cloud provider ili lokalni url.

### Korisni Linkovi
https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-java-with-maven

### Potrebni Alati
1. Java 8 https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
2. Eclipse / IntelliJ / Alat po izboru
3. Docker https://www.docker.com/products/docker-desktop




# Intense DevOps Praktikantski Zadatak - Resenje

Ovaj repozitorijum sadrži moje rešenje praktikantskog zadatka za DevOps poziciju.

---

### 1. Dockerfile
- Napravljen je **multi-stage Dockerfile** (Oracle JDK 8 za lokal, Temurin 8 za cloud/CI).
- Lokalni build koristi **Oracle** base image (tako je navedeno u zadatku pod sekcijom Potrebni alati).
- CI/CD build koristi **`Dockerfile.ci`** sa **Temurin JDK 8** jer je otvoren i dostupan na GitHub Actions/Render.

#### Lokalno (Dockerfile – Oracle JDK 8)

Za lokalni build koristi se Dockerfile sa Oracle JDK 8 (po zahtevu zadatka).

Napomena: pre prvog builda potrebno je da imate Oracle nalog i da potvrdite licencu za `serverjre:8` na [Oracle Container Registry](https://container-registry.oracle.com/).

1. Login na Oracle Container Registry (koristite Oracle nalog):
docker login container-registry.oracle.com
2. Build slike iz Dockerfile-a:
docker build -t intens-api-oracle:dev .
3. Pokretanje kontejnera:
docker run -p 8080:8080 intens-api-oracle:dev


---

### 2. Deployment

#### A) Cloud (Render) – glavni URL
- Service: Render Web Service (Docker)
- Dockerfile: `Dockerfile.ci`
- Env: `PORT=8080`
- URL: https://intens-api-2022-fpwy.onrender.com

#### B) Lokalno (Kubernetes / Minikube)
1. Build local image: docker build -t intens-api-oracle-full:dev .
2. Start Minikube: minikube start --driver=docker
3. Load local image into Minikube: minikube image load intens-api-oracle-full:dev
4. Apply manifests: kubectl apply -f k8s/
5. Get URL and open the app: minikube service intens-api-svc --url

---

### 3. CI/CD (GitHub Actions)

#### CI (Pull Request -> master)
- Workflow: .github/workflows/ci-pr.yml
- Svaki PR prema master grani automatski pokreće Maven testove (mvn test).

#### CD (Push -> master)
- Workflow: .github/workflows/cd-master.yml
- Radi sledeće:
    1. Gradi aplikaciju (mvn clean package).
    2. Gradi i pushuje Docker image (Dockerfile.ci) na GitHub Container Registry:
ghcr.io/zarick1/intens-api-2022:latest
    3. Poziva Render Deploy Hook → Render odmah uradi redeploy sa novom slikom
  

